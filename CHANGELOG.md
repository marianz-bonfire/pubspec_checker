## 1.1.0

+ Added new function to get supported platforms alternatively via score API
+ Added pubspec topics and changed package version

## 1.0.9

* Changed result display to `tabular format` to make it cleaner and easy to scan
+ Added new function to crawl package page if no supported platforms fetch from API
- Removed unnecessary files
- Refactored some codes and remove some unwanted lines of code
+ Added some screenshots for samples
* Modified README to include enhancement details of the package


## 1.0.8

* Upgraded SDK due to some issues encountered from previous published
* Modified some lines to fixed warnings on dart analyze

## 1.0.7
* Fixed the constraint `^0.13.5` on http does not support the stable version `1.0.0`.
* Adjusted the max environment SDK constraint
* Upgraded some dependencies
* Modified README file

## 1.0.6
* Removed unused import

## 1.0.5
* Added resolution on getting supported platforms from API
* Added screenshots lint reported warning
* Added example, using the package functionality in the code

## 1.0.4
### Fixed
* Fixed lint reported warning

## 1.0.3
### Added
+ Added `macos` check support
### Fixed
* Fixed showing links of its package
* Fixed individual platform argument options

## 1.0.2
### Added
+ Added package app image
* Enhanced README file to make it more details
* Formatted dart files as requirements of pub dev
### Fixed
* Resolved dependencies version

## 1.0.1
### Added
+ Added documentation to all classes, methods, and constants across all files for better maintainability and readability.
* Enhanced logging output with detailed formatting and dynamic hyphen padding.
+ Added inline comments in `pubspec_checker_base.dart` for clarity.
* Documented constants.dart, explaining enums, lists, and color codes for terminal output.
### Fixed
* Resolved minor issues with inconsistent log formatting.
Improved compatibility check logic to handle edge cases where no dependencies are found.

## 1.0.0
### Added
+ Initial release of the pubspec_checker package.
+ Supports platform compatibility checks for android, ios, web, windows, linux, and macos.
+ Displays detailed results, including supported and unsupported packages.
+ Provides command-line arguments for flexibility:
    - `-l` to show the list of packages with supported platforms.
    - `-s` to show links to package details.
+ ANSI color-coded terminal output for better visibility.
+ Logs formatted with dynamic hyphen padding for consistent appearance.
