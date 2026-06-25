# VibeCut Frontend (Flutter)

This is the mobile application frontend for the VibeCut app, built with Flutter for iOS and Android.

## UI Screens Created (Phase 2)
We have designed and structured the initial user onboarding and authentication flows inside the `lib/` directory:
- `lib/theme/colors.dart`: Contains the premium AMOLED dark design tokens.
- `lib/screens/welcome_screen.dart`: Onboarding landing screen with premium styling and animations.
- `lib/screens/login_screen.dart`: User login validation and credential inputs.
- `lib/screens/signup_screen.dart`: Register validation and inputs.

## Setup Instructions

### Prerequisites
1. [Flutter SDK installed](https://docs.flutter.dev/get-started/install/windows/mobile?tab=download) and added to your system PATH.
2. Android Studio or VS Code with Flutter and Dart extensions.

### 1. Generate Native Platform Files
Since this project already contains our premium Dart code and custom `pubspec.yaml`, you need to generate the native platform configurations (Android, iOS, Web, etc.).

Navigate to the `frontend` folder in your terminal and run:
```bash
cd "E:\Deepak\D project\vibecut\frontend"
flutter create --org com.deepak.vibecut .
```

*Note: If `flutter create` overwrites `lib/main.dart` or `pubspec.yaml` with default templates, you can easily restore them from Git by running:*
```bash
git checkout -- pubspec.yaml lib/
```

### 2. Run the Application
1. Connect a physical Android/iOS device or launch an emulator.
2. In the `frontend` directory, fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Start the application:
   ```bash
   flutter run
   ```
