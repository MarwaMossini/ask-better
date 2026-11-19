# ProshnoLab

**Ask better. Save time and money.**

ProshnoLab is an early-stage Bangla–English Android app for students in
Bangladesh. The first preview includes:

- A guided prompt builder for **Essay**, **Email** and **Study** tasks.
- Editable prompt previews and copy-to-clipboard.
- A curated Q&A learning library and before/after prompting tips.
- Links to official sources for AI and technology updates.
- A responsive bilingual landing page with a working sample prompt builder.

This is **not yet the competition-ready paid service**. There is no live AI
chatbot, live news feed, BDApps OTP verification, subscription or billing in
the preview. No payment can be collected. The subscription screen explains
this status to testers.

## Android development

The repository contains Flutter source code. The Android platform scaffold is
generated on first setup, keeping the initial repository small:

```bash
flutter create . --platforms=android --project-name proshnolab --org com.proshnolab
flutter pub get
flutter analyze
flutter test
flutter run
```

Use the latest supported Flutter **stable** SDK. To create a test APK locally:

```bash
flutter build apk --debug
```

GitHub Actions runs the same checks and uploads a **debug APK** as a workflow
artifact after each push to `main`. Open the Actions tab, select **Build
Android test APK**, and download the `proshnolab-debug-apk` artifact from a
successful run. The artifact downloads as a ZIP; extract the APK before
installing it on your Android device. Debug APKs are for testing only, not
official Store publication.

## Landing page

`web/index.html` is a standalone responsive landing page. You can open it in
a browser or upload it to HTTPS hosting. It includes a browser-only sample
builder that does not transmit users' answers.

## Project structure

| Path | Purpose |
| --- | --- |
| `lib/main.dart` | Android UI and on-device prompt creation |
| `test/widget_test.dart` | Flutter UI smoke test |
| `web/index.html` | Responsive bilingual landing page |
| `backend/README.md` | Pending BDApps integration safeguards |
| `.github/workflows/android.yml` | Android analysis, tests and APK build |

## Before BDApps publication

1. Verify the Tech Quest submission requirements and deadline.
2. Confirm hosting permissions, HTTPS and stable outbound IPv4.
3. Review the workshop PHP examples and implement approved BDApps integration.
4. Test OTP, active/inactive subscription, callbacks and unsubscribe.
5. Approve the price, billing frequency, subscriber benefits and marketing
   material before taking subscriptions.
6. Prepare a signed release APK and the required Store listing materials.

Never commit passwords, `.env` files, signing keys or subscriber data.
