# Ask Better SMS demo

This PHP 8 service turns an SMS topic into an AI prompt. The proposed keyword is
`ASKBETTER`. Keep charging disabled in provisioning for the demo.

1. Confirm the hosting account's outbound IP and assigned HTTPS folder. Open the
   callback URL without the token first. A browser GET should return HTTP 405
   once HTTPS is trusted. This checks reachability before testing an SMS.
2. Upload only `sms.php` into the assigned public folder. PHP needs cURL and PDO SQLite.
3. Create `ask-better-sms-config.php` one directory above the site's document root,
   outside any web-served directory. Use a hosting account or configuration store
   that other workshop participants cannot access. A student folder under a
   shared cPanel login does not provide that isolation. The file returns an
   array with these keys:

   | Key | Value |
   | --- | --- |
   | `application_id` | App ID from bdapps |
   | `api_password` | SMS API password from bdapps |
   | `callback_token` | Random secret, at least 32 characters |
   | `keyword` | Keyword provisioned in bdapps |
   | `test_senders` | Array of exact bdapps sender addresses for approved test numbers |
   | `state_file` | Absolute path to a writable SQLite file outside the document root |

4. Set the Allowed Host Address to the verified outbound IP and set the Message
   Receiving URL to the uploaded HTTPS endpoint with `?token=<callback_token>`.
   Confirm that provisioning preserves the query string. Treat the callback URL
   as private and avoid recording its query string in access logs.
5. Once the SMS request is approved, keep charging off and whitelist the test
   number. Use an approved Robi number for the first test, since Robi is the
   configured operator. Send the assigned keyword plus a topic to the assigned
   shortcode and confirm the same phone receives one reply.

Run `php backend/bdapps/smoke-test.php` for a simulated callback. It substitutes
a fake sender function, so it cannot send a real SMS. Each accepted request ID
is claimed before sending. If a send outcome is ambiguous, retry the demo with
a new inbound SMS to avoid a duplicate reply.
