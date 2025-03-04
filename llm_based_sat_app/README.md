# LLM-Based Mobile App for Mental Health

## Contributors
- [Shivit Kapoor (sk3122)](https://github.com/SHivit700)
- [Harini Sritharar (hs1922)](https://github.com/Harini-Sritharar)
- [Nisarg Brahmbhatt (nb1622)](https://github.com/NisargBrahmbhatt4778)
- [Dylan Kamath (dk2222)](https://github.com/dylankam)
- [Shivangi Kumar (sk2922)](https://github.com/15skumar)
- [Rohan Shah (rs1822)](https://github.com/RohanShah10)

## Table of Contents
1. [Getting Started](#getting-started)
2. [How to Clone](#how-to-clone)
3. [How to Run](#how-to-run)
4. [How to Deploy](#how-to-deploy)
5. [Maintaining the App](#maintaining-the-app)
6. [Editing the App Icon/Logo](#editing-the-app-iconlogo)
7. [Editing the App Name](#editing-the-app-name)
8. [License](#license)

## Getting Started

### Prerequisites
- Flutter SDK installed (version 3.27.1)
- Dart SDK installed (bundled with Flutter)
- VSCode (or equivalent editor)
- Git

#### Android Development
- Android Studio (for Android emulator)
- Android SDK (version 35.0.0 or higher)
- JDK 17
- Gradle (may be installed through Android Studio)

#### iOS Development
- XCode (for iOS emulator)
- Cocoapods

## How to Clone
GitHub has deprecated password authentication for Git over HTTPS. There are two options for cloning the repo:

1. **SSH Keys (Recommended)**
   - Check if you already have an SSH Key pair
   - Generate a new SSH key if not already available
   - Add the SSH key to the SSH Agent
   - Add the SSH key to GitHub
   - Now you should be able to clone using SSH without the need to input any credentials.

2. **Create a PAT on GitHub**
   - Navigate to `Settings -> Developer Settings -> Personal Access Tokens -> Tokens (classic) -> Generate New Token`
   - Now you should be able to clone using HTTPS, providing your GitHub username and PAT as the password.

## How to Run
- Ensure you are in the root project directory.
- Run `flutter pub get` to fetch the dependencies.
- Run `flutter run` to launch the application on a selected device/emulator.
- Run `flutter test` to execute tests.

## How to Deploy

### Android (Play Store)
- Run `flutter build apk --release` to generate a release APK.
- Sign the APK.
- Upload the APK to the Google Play Console.

### iOS (App Store)
- Run `flutter build ios --release` to build the iOS app.
- Upload the app using XCode to the App Store.

Both of these commands are executed in our CI pipeline when merging branches to `main`.

## Maintaining the App
### Firebase Configuration
- Ensure Firebase is correctly configured for authentication, Firestore, and messaging.
- Background message handling is set up in `main.dart` with `firebaseMessagingBackgroundHandler`.
- `FirebaseAppCheck` is activated to protect against abuse.

### Environment Variables
- The `.env` file should contain sensitive keys such as `STRIPE_PUBLISHABLE_KEY`.
- Load environment variables using `flutter_dotenv`.

### Push Notifications
- Push notifications are managed by `FirebaseMessagingService`.
- Ensure the `FCMInitializer` widget is included in `main.dart` to keep notifications working.

### Stripe Payments
- The app integrates `flutter_stripe` for payment processing.
- Ensure Stripe API keys are correctly set up in `.env`.

### User Authentication & Profile Data
- The app initializes user data upon login and fetches profile details from Firestore (`Profile` collection).
- Ensure Firebase Authentication is correctly configured.

### Updating Dependencies
- Run `flutter pub outdated` to check for outdated dependencies.
- Run `flutter pub upgrade` to update dependencies.
- Test the app thoroughly after upgrading to avoid breaking changes.

### Debugging & Logging
- Errors are logged in the console.
- Consider integrating Firebase Crashlytics for better error tracking.


## Editing the App Icon/Logo
- Add your new logo in `assets/icons/logo/`.
- Update `flutter_icons` in `pubspec.yaml` to point to the new logo.
- Run:
  ```sh
  flutter pub get
  flutter pub run flutter_launcher_icons
  ```
- Restart the app to see the changes.

## Editing the App Name
- Change `android:label` in `android/app/src/main/AndroidManifest.xml` and `android/app/src/debug/AndroidManifest.xml`.
- Change `CFBundleName` in `/ios/Runner/Info.plist`.

## License
This project is licensed under the [License Name] license.
