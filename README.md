# Ask Better

Ask Better helps users turn a topic and a few details into a prompt they can paste into an AI tool. The website and Android app support English and Bangla. The Flutter package uses the original name, `proshnolab`.

- [Open the web app](https://marwamossini.github.io/ask-better/app/)
- [Visit the project website](https://marwamossini.github.io/ask-better/)
- [Download the Android test APK](https://marwamossini.github.io/ask-better/downloads/ask-better-test.apk)

For a quick demo, enter **Food waste** as the topic, add a few details, and generate a prompt. Blank answers are skipped. Copy the result or use one of the AI shortcuts to open an external tool. The APK is a debug build. The full download passed an archive integrity check. Installation and launch on a physical Android phone are still unverified.

## Where to find the code

| Path | Purpose |
| --- | --- |
| [`site/`](site/) | Public landing page, sample builder, and website assets |
| [`lib/main.dart`](lib/main.dart) | Flutter app for Android and the browser, including the prompt builder and learning library |
| [`web/`](web/) | Flutter web entry point |
| [`test/widget_test.dart`](test/widget_test.dart) | Flutter widget tests |
| [`backend/bdapps/sms.php`](backend/bdapps/sms.php) | PHP callback that formats an SMS topic into a prompt |
| [`backend/bdapps/smoke-test.php`](backend/bdapps/smoke-test.php) | Simulated SMS callback test |
| [`.github/workflows/`](.github/workflows/) | Build, test, and GitHub Pages workflows |

## Run the Flutter app

Use Flutter stable with the minimum versions listed in [`pubspec.yaml`](pubspec.yaml), an Android SDK for Android, or Chrome for the browser.

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

For an Android device or emulator, generate the Android scaffold, then select the device with `flutter run`.

```bash
flutter create . --platforms=android --project-name proshnolab --org com.proshnolab
flutter run
```

The [Android workflow](.github/workflows/android.yml) runs analysis and widget tests and builds the debug APK. The [Pages workflow](.github/workflows/pages.yml) publishes the landing page, browser app, and downloadable APK.

## SMS demo status

The SMS callback code has [passed its simulated test](https://github.com/MarwaMossini/ask-better/actions/runs/44895784332). The PHP callback was uploaded to the AUW workshop hosting. The current callback URL produced a browser certificate warning, so HTTPS is still unverified. The last status verified for the bdapps SMS request was **Robi: Draft**. The Charging SDK is off, and no live SMS reply has been verified. See the [SMS setup notes](backend/bdapps/README.md) for PHP requirements, callback configuration, and the test command.
