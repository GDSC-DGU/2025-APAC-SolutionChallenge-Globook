# Globook Client

Globook is an application that helps you read e-books. This project is built using Flutter and follows a clean architecture pattern with GetX for state management.

## Table of Contents

- [Getting Started](#getting-started)
- [Project Architecture](#project-architecture)
- [Development Guide](#development-guide)
- [Troubleshooting](#troubleshooting)
- [References](#references)

## Getting Started

### Prerequisites

- Flutter SDK (3.4.3 or higher)
  - To check your Flutter version: `flutter --version`
  - To upgrade Flutter: `flutter upgrade`
- Dart SDK
  - Included with Flutter installation
  - To check Dart version: `dart --version`
- Android Studio / Xcode
  - Android Studio: Latest version with Flutter and Dart plugins
  - Xcode: Latest version for iOS development
- Firebase Account
  - Create a new project in [Firebase Console](https://console.firebase.google.com/)
  - Enable Authentication, Firestore, and Storage services
- Git
  - Latest version recommended
  - To check Git version: `git --version`

### Installation and Setup

1. Clone the repository

```bash
# Clone the repository
git clone [repository-url]

# Navigate to project directory
cd globook_client

# Check if you're on the correct branch
git branch
```

2. Install dependencies

```bash
# Get all dependencies
flutter pub get

# Verify installation
flutter doctor
```

3. Create environment configuration

   - Copy the example environment file:

   ```bash
   cp assets/config/.dev.env.example assets/config/.dev.env
   ```

   - Edit `.dev.env` and set your API server URL:

   ```
   API_SERVER_URL=https://your-api-server-url.com
   ```

   - Make sure the file is in the correct location:

   ```
   assets/
   └── config/
       └── .dev.env
   ```

4. Firebase Setup

   #### Android

   1. Go to [Firebase Console](https://console.firebase.google.com/)
   2. Select your project
   3. Click on Android icon to add Android app
   4. Enter your package name (found in `android/app/build.gradle`)
   5. Download `google-services.json`
   6. Place it in `android/app/google-services.json`
   7. Copy `lib/firebase_options.example.dart` to `lib/firebase_options.dart`
   8. Fill in the values from your Firebase project settings in `firebase_options.dart`
   9. Update `android/app/build.gradle`:

   ```gradle
   dependencies {
       implementation platform('com.google.firebase:firebase-bom:32.7.0')
       implementation 'com.google.firebase:firebase-analytics'
   }
   ```

   #### iOS

   1. Go to [Firebase Console](https://console.firebase.google.com/)
   2. Select your project
   3. Click on iOS icon to add iOS app
   4. Enter your bundle ID (found in Xcode)
   5. Download `GoogleService-Info.plist`
   6. Place it in `ios/Runner/GoogleService-Info.plist`
   7. Copy `lib/firebase_options.example.dart` to `lib/firebase_options.dart`
   8. Fill in the values from your Firebase project settings in `firebase_options.dart`
   9. Update `ios/Podfile`:

   ```ruby
   platform :ios, '12.0'
   ```

5. Generate Environment code for Setting .dev.env

```bash
# Generate code
flutter pub run build_runner build

# If you encounter any issues, try cleaning first
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

6. Run the app

```bash
# For development
flutter run

# For release build
flutter run --release

# For specific device
flutter run -d <device-id>
```

## Project Architecture

### Directory Structure

```
lib/
├── app/                    # Application layer
│   ├── config/            # App configuration
│   ├── env/               # Environment settings
│   ├── middleware/        # Middleware components
│   └── utility/           # Utility functions
├── core/                  # Core functionality
├── data/                  # Data layer
│   ├── factory/          # Factory classes
│   ├── model/            # Data models
│   ├── provider/         # Data providers
│   └── repository/       # Data repositories
├── domain/               # Domain layer
├── presentation/         # Presentation layer
│   ├── view/            # UI screens
│   ├── view_model/      # View models
│   └── widget/          # Reusable widgets
└── main.dart             # Application entry point
```

### Architecture Overview

#### Application Layer (`lib/app/`)

- Configuration management
- Environment setup
- Middleware components
- Utility functions

#### Data Layer (`lib/data/`)

- Data models
- Data providers
- Data repositories
- Factory classes for dependency injection

#### Presentation Layer (`lib/presentation/`)

- UI screens
- View models
- Reusable widgets
- State management

#### Core Layer (`lib/core/`)

- Core functionality
- Common utilities
- Base classes

#### Domain Layer (`lib/domain/`)

- Business logic
- Use cases
- Domain models

### State Management

- Using GetX for state management
- View models are located in `lib/presentation/view_models/`
- Controllers handle business logic and state updates
- Example of a view model:

```dart
class HomeViewModel extends GetxController {
  final _books = <Book>[].obs;

  List<Book> get books => _books;

  void fetchBooks() async {
    // Implementation
  }
}
```

## Development Guide

### Environment Variables

- `.dev.env`: Development environment configuration file (not included in Git)
  - Contains sensitive information
  - Should never be committed
- `.dev.env.example`: Example environment variables file
  - Template for creating `.dev.env`
  - Safe to commit

### Firebase Configuration

- `firebase_options.dart`: Firebase configuration file (not included in Git)
  - Contains Firebase project settings
  - Generated from Firebase Console
- `firebase_options.example.dart`: Example Firebase configuration file
  - Template for creating `firebase_options.dart`
  - Safe to commit
- `google-services.json`: Android Firebase configuration file (not included in Git)
- `GoogleService-Info.plist`: iOS Firebase configuration file (not included in Git)

### Code Style

- Follow Flutter's official style guide
- Use meaningful variable and function names
- Add comments for complex logic
- Keep files focused and small
- Use proper indentation (2 spaces)

### Git Workflow

1. Create a new branch for each feature
2. Make small, focused commits
3. Write clear commit messages
4. Create pull requests for code review
5. Merge only after approval

## Troubleshooting

1. If you encounter build errors

```bash
# Clean the project
flutter clean

# Get dependencies again
flutter pub get

# Regenerate code
flutter pub run build_runner build --delete-conflicting-outputs

# Check for any issues
flutter doctor -v
```

2. If you encounter Firebase-related errors

- Verify your Firebase project settings in Firebase Console
- Check if configuration files are in the correct locations
- Verify the values in `firebase_options.dart`
- Make sure Firebase services are enabled
- Check Firebase Console for any error messages

3. If you encounter environment-related errors

- Make sure `.dev.env` file exists and contains correct values
- Run `flutter pub run build_runner build` to regenerate environment code
- Check if the API server URL is accessible
- Verify environment variables are being loaded correctly

4. Common iOS-specific issues

- Run `pod install` in the `ios` directory
- Update CocoaPods: `sudo gem install cocoapods`
- Clean Xcode build folder
- Reset iOS simulator

5. Common Android-specific issues

- Update Gradle version
- Clean Android build
- Update Android SDK tools
- Check device compatibility

## References

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Flutter Guide](https://firebase.flutter.dev/docs/overview)
- [GetX Package Documentation](https://pub.dev/packages/get)
- [Flutter Environment Variables Guide](https://docs.flutter.dev/development/tools/sdk/release-notes/release-notes-3.7.0#environment-variables)
- [Flutter Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
