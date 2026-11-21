# Ask Better backend

The [SMS demo](bdapps/README.md) contains the PHP callback and a simulated test. Live SMS setup and verification are pending.

## Future OTP, subscription, and billing work

The Android preview currently has no OTP verification, payment collection, or subscription management.

This folder intentionally contains no BDApps passwords, access tokens,
subscriber phone numbers, or copies of the workshop PHP examples. Before
implementing endpoints:

1. Audit the workshop `send_otp.php`, `verify_otp.php`,
   `check_subscription.php`, `subscription_listener.php`, and
   `unsubscribe.php` examples.
2. Confirm which BDApps-approved consent/OTP/charging flow applies to our Pro
   application. Do not enable SMS/USSD unless actually needed.
3. Verify that the cPanel account is private, uses HTTPS, and can make
   outbound HTTPS requests from an IPv4 address whitelisted by BDApps.
4. Store all BDApps secrets outside the public web root, preferably as
   server-side environment variables or access-restricted configuration.
5. Validate callbacks and subscription states server-side. Never unlock
   subscriber features based only on a value sent by the Android app.
6. Add rate limiting, safe logging, error handling and subscription tests.
7. Confirm the approved price, billing frequency, consent text, and
   unsubscribe process before allowing real charges.

Reference: https://dev.bdapps.com/bdapps-pro.php
