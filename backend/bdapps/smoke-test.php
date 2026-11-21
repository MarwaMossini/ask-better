<?php

declare(strict_types=1);

require __DIR__ . '/sms.php';

$db = tempnam(sys_get_temp_dir(), 'ask-better-');
if ($db === false) {
    throw new RuntimeException('Could not create test state file.');
}
$config = [
    'application_id' => 'APP_TEST',
    'api_password' => 'test-only',
    'callback_token' => str_repeat('a', 32),
    'test_senders' => ['tel:8801800000000'],
    'keyword' => 'ASKBETTER',
    'state_file' => $db,
];
$event = [
    'applicationId' => 'APP_TEST',
    'sourceAddress' => 'tel:8801800000000',
    'encoding' => '0',
    'requestId' => 'demo-1',
    'message' => 'ASKBETTER food waste',
];
$sent = [];
$send = static function (array $payload) use (&$sent): bool {
    $sent[] = $payload;
    return true;
};
$receive = static fn (array $message, ?string $token): int =>
    handleSms($config, ['token' => $token], json_encode($message, JSON_THROW_ON_ERROR), $send);
$check = static function (bool $condition, string $label): void {
    if (!$condition) {
        throw new RuntimeException($label);
    }
};

try {
    $check($receive($event, null) === 403, 'Missing callback token');
    $token = $config['callback_token'];
    $check($receive(array_replace($event, ['applicationId' => 'OTHER']), $token) === 400, 'Wrong app');
    $check($receive(array_replace($event, ['sourceAddress' => 'tel:all']), $token) === 200, 'Blocked sender');
    $check($sent === [], 'Untrusted request sent a reply');
    $check($receive($event, $token) === 200, 'Valid callback');
    $check($receive($event, $token) === 200, 'Duplicate callback');
    $check(count($sent) === 1, 'Duplicate reply');
    $check($sent[0]['destinationAddresses'] === [$event['sourceAddress']], 'Reply destination');
    $check(str_ends_with($sent[0]['message'], 'Topic: food waste'), 'Prompt text');
    $check($receive(array_replace($event, ['requestId' => 'demo-2', 'message' => 'ASKBETTER']), $token) === 200, 'Help callback');
    $check(str_contains($sent[1]['message'], 'followed by a topic'), 'Help text');
    echo "SMS backend smoke tests passed. No SMS sent.\n";
} finally {
    unlink($db);
}
