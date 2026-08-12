# Installation Instructions

## Prerequisites

Before running the project, ensure the following software is installed on your machine:

- Flutter SDK (latest stable version)
- Dart SDK (included with Flutter)
- Git
- Android Studio (for Android development)
- Xcode (macOS only, for iOS development)
- Visual Studio Code or Android Studio (recommended IDE)

## Clone the Repository

```bash
git clone <repository-url>
cd <repository-folder>
```

## Install Flutter Dependencies

Download all required packages by running:

```bash
flutter pub get
```

## Configure Firebase

This project uses Firebase services.

1. Create a Firebase project or use the provided project credentials.
2. Enable the required Firebase services:
   - Authentication
   - Cloud Firestore
   - Firebase AI
3. Download the Firebase configuration files:
   - `google-services.json` for Android
   - `GoogleService-Info.plist` for iOS
4. Place each configuration file in its corresponding platform directory.

> **Note:** The Firebase configuration files are not included in the repository for security reasons.

## Android Setup

1. Install Android Studio.
2. Install:
   - Android SDK
   - Android SDK Platform Tools
   - Android Emulator (optional)
3. Accept Android licenses:

```bash
flutter doctor --android-licenses
```

4. Verify the installation:

```bash
flutter doctor
```

## iOS Setup (macOS Only)

1. Install Xcode from the App Store.
2. Install CocoaPods if it is not already installed:

```bash
sudo gem install cocoapods
```

3. Install iOS dependencies:

```bash
cd ios
pod install
cd ..
```

4. Verify the installation:

```bash
flutter doctor
```

## Running the Application

To run the application on a connected device or emulator:

```bash
flutter run
```

Run specifically on Android:

```bash
flutter run -d android
```

Run specifically on iOS:

```bash
flutter run -d ios
```

## Building the Application

Generate an Android APK:

```bash
flutter build apk
```

Generate an Android App Bundle:

```bash
flutter build appbundle
```

Generate an iOS release build (macOS only):

```bash
flutter build ios
```

## Troubleshooting

If dependencies become corrupted, run:

```bash
flutter clean
flutter pub get
```

To verify your Flutter environment:

```bash
flutter doctor
```

Resolve any reported issues before attempting to run the project.

## Additional Notes

- A physical Android device or emulator is required to run the Android version.
- A Mac with Xcode is required to build or run the iOS version.
- Internet access is required during the first launch to download project dependencies and initialize Firebase services.
