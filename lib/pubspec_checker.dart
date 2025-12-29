/// The main library file for the `pubspec_checker` package.
///
/// This library provides a comprehensive toolkit for analyzing Dart/Flutter
/// package dependencies and checking their platform compatibility.
///
/// ## Overview
///
/// The `pubspec_checker` package helps developers verify that their project
/// dependencies are compatible with target platforms (Android, iOS, Web, etc.).
/// It parses `pubspec.yaml`, queries pub.dev APIs, and provides detailed
/// compatibility reports.
///
/// ## Getting Started
///
/// Add the package to your `pubspec.yaml`:
/// ```yaml
/// dependencies:
///   pubspec_checker: ^1.0.0
/// ```
///
/// Import the library:
/// ```dart
/// import 'package:pubspec_checker/pubspec_checker.dart';
/// ```
///
/// ## Core Components
///
/// 1. **[PackageChecker]**: Main entry point for checking platform compatibility
/// 2. **[PlatformChecker]**: Utility for checking specific package compatibility
/// 3. **[PubspecReader]**: Reads and parses `pubspec.yaml` dependencies
/// 4. **[PackagePlatform]**: Enumeration of supported platforms
/// 5. **[PlatformStatus]**: Enumeration of compatibility statuses
///
/// ## Example Usage
///
/// ```dart
/// import 'package:pubspec_checker/pubspec_checker.dart';
///
/// void main() async {
///   // Create a package checker instance
///   final checker = PackageChecker();
///
///   // Check compatibility for specific platforms
///   await checker.checkAll([
///     PackagePlatform.android,
///     PackagePlatform.ios,
///     PackagePlatform.web,
///   ], showLink: true);
///
///   // Or check a single platform
///   await checker.checkPlatform(
///     PackagePlatform.android,
///     showIcon: false,
///   );
/// }
/// ```
///
/// ## Features
///
/// - ✅ Parses `pubspec.yaml` dependencies automatically
/// - ✅ Checks compatibility with multiple platforms
/// - ✅ Provides console-friendly formatted output
/// - ✅ Includes platform status icons (with option to disable)
/// - ✅ Shows package links to pub.dev
/// - ✅ Handles unknown packages gracefully
/// - ✅ Performance timing for compatibility checks
///
/// ## Output Example
///
/// ```
/// ---------------------------------------------------------
/// Package Name        | android |   ios    |   web    | link                   |
/// ---------------------------------------------------------
/// provider           |   ✅     |   ✅     |   ❌     | https://pub.dev/packages/provider |
/// http               |   ✅     |   ✅     |   ✅     | https://pub.dev/packages/http     |
/// ---------------------------------------------------------
/// ✅ Supported       |    2    |    2     |    1     |                        |
/// ❌ Not Supported   |    0    |    0     |    1     |                        |
/// ❔ Unknown         |    0    |    0     |    0     |                        |
/// ---------------------------------------------------------
/// ```
///
/// ## Platform Support
///
/// The package currently supports checking compatibility for:
/// - Android (`PackagePlatform.android`)
/// - iOS (`PackagePlatform.ios`)
/// - Windows (`PackagePlatform.windows`)
/// - macOS (`PackagePlatform.macos`)
/// - Linux (`PackagePlatform.linux`)
/// - Web (`PackagePlatform.web`)
///
/// ## Notes
///
/// - The package requires an internet connection to query pub.dev APIs
/// - Platform compatibility data is sourced from pub.dev metadata
/// - Multiple fallback strategies are used when platform data is incomplete
/// - Network errors and missing packages are handled gracefully
///
/// ## See Also
///
/// - [pub.dev package page](https://pub.dev/packages/pubspec_checker)
/// - [GitHub repository](https://github.com/yourusername/pubspec_checker)
/// - [API documentation](https://pub.dev/documentation/pubspec_checker/latest/)
library;

export 'src/pubspec_checker_base.dart'
    show PackageChecker, PackagePlatform, PlatformStatus;

export 'src/platform_checker.dart' show PlatformChecker, PackageCompatibility;

export 'src/pubspec/pubspec_reader.dart' show PubspecReader;
