## [1.0.1] - 2024-12-21
### Added
+ Added documentation to all classes, methods, and constants across all files for better maintainability and readability.
* Enhanced logging output with detailed formatting and dynamic hyphen padding.
+ Added inline comments in `pubspec_checker_base.dart` for clarity.
* Documented constants.dart, explaining enums, lists, and color codes for terminal output.
### Fixed
* Resolved minor issues with inconsistent log formatting.
Improved compatibility check logic to handle edge cases where no dependencies are found.

## [1.0.0] - 2024-12-20
### Added
+ Initial release of the pubspec_checker package.
+ Supports platform compatibility checks for android, ios, web, windows, linux, and macos.
+ Displays detailed results, including supported and unsupported packages.
+ Provides command-line arguments for flexibility:
    - `-l` to show the list of packages with supported platforms.
    - `-s` to show links to package details.
+ ANSI color-coded terminal output for better visibility.
+ Logs formatted with dynamic hyphen padding for consistent appearance.
