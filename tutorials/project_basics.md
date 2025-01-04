# Flutter Project Structure

## Basic Project Files and Directories

### `lib/` Directory
- Main directory containing Dart source code
- Contains `main.dart` (application entry point)
- Where you place all your custom widgets and logic

### `android/` Directory
- Contains Android-specific configuration and code
- Important files:
    - `build.gradle` - Android build settings
    - `AndroidManifest.xml` - App permissions and metadata

### `ios/` Directory
- Contains iOS-specific configuration and code
- Important files:
    - `Info.plist` - iOS app settings
    - `Runner.xcworkspace` - Xcode workspace

### `pubspec.yaml`
- Project configuration file
- Defines:
    - Dependencies
    - Assets (images, fonts)
    - App version
    - SDK constraints

### `test/` Directory
- Contains unit and widget tests
- `widget_test.dart` - Default widget test file

### Other Important Files
- `.gitignore` - Git ignore rules
- `README.md` - Project documentation
- `analysis_options.yaml` - Dart analyzer settings

## Generated Files
- `build/` - Build output directory
- `.dart_tool/` - Dart build system files
- `.metadata` - Flutter project metadata