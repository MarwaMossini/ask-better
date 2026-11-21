<?php

declare(strict_types=1);

function handleSms(array $config, array $query, string $body, callable $send): int
{
    $token = $query['token'] ?? null;
    if (!is_string($token) || !hash_equals($config['callback_token'], $token)) {
        return 403;
    }

    $event = json_decode($body, true);
    $sender = $event['sourceAddress'] ?? null;
    $message = $event['message'] ?? null;
    $requestId = $event['requestId'] ?? null;
    if (($event['applicationId'] ?? null) !== $config['application_id']
        || ($event['encoding'] ?? null) !== '0'
        || !is_string($sender) || !is_string($message)
        || !is_string($requestId) || $requestId === '' || strlen($requestId) > 128) {
        return 400;
    }

    // Use the exact sender address supplied by bdapps, including masked addresses.
    if (!in_array($sender, $config['test_senders'], true)
        || !preg_match('/\Atel:[a-zA-Z0-9+._=-]+\z/', $sender)
        || strcasecmp($sender, 'tel:all') === 0) {
        return 200;
    }

    $keyword = $config['keyword'];
    $topic = trim(preg_replace('/\s+/u', ' ', $message) ?? '');
    // Accept callbacks that include the keyword and callbacks that strip it.
    $topic = preg_replace('/\A' . preg_quote($keyword, '/') . '(?: |$)/i', '', $topic);
    $reply = $topic === ''
        ? "Ask Better: text $keyword followed by a topic, e.g. $keyword food waste."
        : "Explain this topic in plain language and give two practical examples. Topic: $topic";

    // A private SQLite file makes repeated callbacks safe across PHP workers.
    $db = new PDO('sqlite:' . $config['state_file']);
    $db->exec('PRAGMA busy_timeout = 5000');
    $db->exec('CREATE TABLE IF NOT EXISTS handled (request_id TEXT PRIMARY KEY)');
    $claim = $db->prepare('INSERT OR IGNORE INTO handled VALUES (?)');
    $claim->execute([$requestId]);
    if ($claim->rowCount() === 0) {
        return 200;
    }

    // Keep the claim on network errors because the provider may already have sent it.
    return $send([
        'version' => '1.0',
        'applicationId' => $config['application_id'],
        'password' => $config['api_password'],
        'message' => $reply,
        'destinationAddresses' => [$sender],
        'encoding' => '0',
    ]) ? 200 : 502;
}

function sendBdappsSms(array $payload): bool
{
    $curl = curl_init('https://developer.bdapps.com/sms/send');
    curl_setopt_array($curl, [
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => json_encode($payload, JSON_THROW_ON_ERROR),
        CURLOPT_HTTPHEADER => ['Content-Type: application/json'],
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_CONNECTTIMEOUT => 4,
        CURLOPT_TIMEOUT => 8,
    ]);
    $body = curl_exec($curl);
    $status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    $response = is_string($body) ? json_decode($body, true) : null;
    return $status === 200
        && ($response['statusCode'] ?? null) === 'S1000'
        && ($response['destinationResponses'][0]['statusCode'] ?? null) === 'S1000';
}

if (PHP_SAPI === 'cli') {
    return;
}

header('Content-Type: application/json; charset=utf-8');
$status = 503;
try {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        header('Allow: POST');
        $status = 405;
    } else {
        $configPath = dirname($_SERVER['DOCUMENT_ROOT']) . '/ask-better-sms-config.php';
        if (is_file($configPath)) {
            $config = require $configPath;
            if (strlen($config['callback_token'] ?? '') >= 32
                && !empty($config['application_id']) && !empty($config['api_password'])
                && !empty($config['keyword']) && !empty($config['state_file'])) {
                $body = file_get_contents('php://input', false, null, 0, 8193);
                $status = strlen($body) > 8192
                    ? 413 : handleSms($config, $_GET, $body, 'sendBdappsSms');
            }
        }
    }
} catch (Throwable) {
    $status = 500;
}
if ($status >= 500) {
    error_log('Ask Better SMS callback failed (HTTP ' . $status . ').');
}
http_response_code($status);
echo json_encode($status === 200
    ? ['statusCode' => 'S1000', 'statusDetail' => 'Success.']
    : ['statusDetail' => 'Request could not be processed.']);
