# trash_track

A mobile application for tracking waste management.

## Development Setup Guide

### Prerequisites
1. Install the following software:
   - [Android Studio](https://developer.android.com/studio)
   - [Flutter SDK](https://flutter.dev/docs/get-started/install)
   - [Git](https://git-scm.com/downloads)

### Setting up the Project in Android Studio
1. **Install Flutter and Dart plugins**
   - Open Android Studio
   - Navigate to `Plugins`
   - Search for "Flutter" and install it (this will also install the Dart plugin)
   - Restart Android Studio

2. **Clone the Repository**
   ```bash
   git clone https://github.com/alphas12/trash_track.git
   ```

3. **Open the Project**
   - Open Android Studio
   - Click on `File > Open`
   - Navigate to the cloned `trash_track` directory
   - Click `Open`
   - Wait for Android Studio to detect Flutter framework and download dependencies

4. **Get Dependencies**
   - Open the terminal in Android Studio (`View > Tool Windows > Terminal`)
   - Run: `flutter pub get`

5. **Set up an Emulator**
   - Go to `Tools > Device Manager`
   - Click on `Create Device`
   - Select a phone model (e.g., Pixel 4)
   - Download and select a system image (recommend: API 35 )
   - Complete the emulator setup with default settings

### Running the Project
1. Select your emulator from the device dropdown menu
2. Click the 'Run' button (green play button) or press `^ R` (Mac) / `Shift+F10` (Windows)

### Development Workflow
1. Create a new branch for your feature/fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and test them thoroughly

3. Commit your changes:
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

4. Push your branch and create a pull request:
   ```bash
   git push origin feature/your-feature-name
   ```

### Project Structure

The project follows a standard Flutter project structure:

```dart
lib/               # Main source code directory
├── main.dart      # Application entry point (This is where your app starts!)
├── screens/       # UI screens/pages
├── widgets/       # Reusable widgets
├── models/        # Data models
├── services/      # Business logic and services
├── utils/         # Utility functions and constants
└── providers/     # State management providers

test/             # Test files
├── unit/         # Unit tests
└── widget/       # Widget tests
```

When creating new files:
1. All Dart source code files go under the `lib/` directory
2. Create appropriate subdirectories based on the file's purpose:
   - UI screens go in `lib/screens/`
   - Reusable widgets go in `lib/widgets/`
   - Data models go in `lib/models/`
   - Services and APIs go in `lib/services/`
   - Helper functions go in `lib/utils/`
3. Tests should be placed in the `test/` directory


### Code Style Guidelines

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Write unit tests for new features

### Useful Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Programming Language](https://dart.dev/)
- [Flutter Packages](https://pub.dev/)
- [Android Studio Documentation](https://developer.android.com/studio/intro)

### Need Help?
- Check the [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)
- Join the [Flutter Discord Community](https://discord.gg/flutter)
- Stack Overflow tags: [flutter](https://stackoverflow.com/questions/tagged/flutter), [dart](https://stackoverflow.com/questions/tagged/dart)
