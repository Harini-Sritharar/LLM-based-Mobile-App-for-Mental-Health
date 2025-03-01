# LLM Based Mobile App for Mental Health

# Contributors
- [Harini Sritharar (hs1922)](https://github.com/Harini-Sritharar)
- [Shivangi Kumar (sk2922)](https://github.com/15skumar)
- [Rohan Shah (rs1822)](https://github.com/RohanShah10)
- [Dylan Kamath (dk2222)](https://github.com/dylankam)
- [Shivit Kapoor (sk3122)](https://github.com/SHivit700)
- [Nisarg Brahmbhatt (nb1622)](https://github.com/NisargBrahmbhatt4778)

# Table of Contents
1. [Getting Started](#getting-started)
2. [How to clone](#how-to-clone)
3. [How to run](#how-to-run)
4. [How to deploy](#how-to-deploy)
5. [License](#license)

# Getting Started

### Prerequisites
- Flutter SDK installed (version 3.27.2 of Flutter)
- Dart SDK installed (will most likely be bundled with Flutter) 
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
 
# How to clone
GitHub has deprecated password authentication for Git over HTTPS. There are now two options for cloning the repo:
1. ### SSH Keys (Recommended)
- Check if you already have an SSH Key pair
- Generate a new SSH key if not already available
- Add the SSH key to the SSH Agent
- Add the SSH key to GitHub
- Now you should be able to clone using SSH, without the need to input in any credentials.

2. ### Create a PAT on GitHub 
- Navigate to Settings -> Developer Settings -> Personal Access Tokens -> Tokens(classic) -> Generate New Token
- Now you should be able to clone using HTTPS, providing your GitHub username and PAT as the password

# How to run
- Ensure you are in the root project directory
- Run `flutter pub get` command to fetch the dependencies
- Run `flutter run` to run the application on the selected device/ emulator
- Run `flutter test` to run tests

# How to deploy
### Android (Play Store)
- Run `flutter build apk --release` to generate a release APK
- Sign the APK
- Upload the APK to the Google Play Console 

### iOS (App Store)
- Run `flutter build ios --release` to build the iOS app
- Upload the app using XCode to the App Store

Both of these commands are run in our CI pipeline when we merge our branches to main.

# Directory structure
- `/android` has all the Android specific code
- `/ios` has all the iOS specific code
- `/test` stores all of our test code; when `flutter test` is run, this command executes all the test files (ending in _test.dart) in this directory.
- `/lib` is the folder that stores the bulk of our code that is shared amongst the iOS and Android versions of the app. we have internally organised this directory into subfolders differentiating between screens, widgets, data and functions to communicate with external services like Firebase.

# Editing the App Icon/Logo
- Add your new logo in assets/icons/logo/..
- Update the image_path in the flutter_icons section of the pubspec.yaml to point to your new logo
- Run flutter pub get
- Run flutter pub run flutter_launcher_icons
You should now be able to run the app and observe the new icon

# Editing the App Name
- Change the android:label field in android/app/src/main/AndroidManifest.xml and android/app/src/debug/AndroidManifest.xml to be the new app name
- Change the CFBundleName field string in /ios/Runner/Info.plist to be the new app name
# License
This project is licensed under the [License Name] license.
