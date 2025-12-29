<p align="center">
  <a href="https://pub.dev/packages/pubspec_checker">
    <img height="260" src="https://raw.githubusercontent.com/marianz-bonfire/pubspec_checker/master/assets/logo.png">
  </a>
  <h1 align="center">Pubspec Checker</h1>
</p>

<p align="center">
  <a href="https://pub.dev/packages/pubspec_checker">
    <img src="https://img.shields.io/pub/v/pubspec_checker?label=pub.dev&labelColor=333940&logo=dart">
  </a>
  <a href="https://pub.dev/packages/pubspec_checker/score">
    <img src="https://img.shields.io/pub/points/pubspec_checker?color=2E8B57&label=pub%20points">
  </a>
  <a href="https://github.com/marianz-bonfire/pubspec_checker/actions/workflows/dart.yml">
    <img src="https://github.com/marianz-bonfire/pubspec_checker/actions/workflows/dart.yml/badge.svg">
  </a>
  <a href="https://pub.dev/packages/pubspec_checker/publisher">
    <img src="https://img.shields.io/pub/publisher/pubspec_checker.svg">
  </a>
  <a href="https://tarsier-marianz.blogspot.com">
    <img src="https://img.shields.io/static/v1?label=website&message=tarsier-marianz&labelColor=135d34&logo=blogger&logoColor=white&color=fd3a13">
  </a>
</p>

<p align="center">
  <a href="https://pub.dev/documentation/pubspec_checker/latest/">Documentation</a> •
  <a href="https://github.com/marianz-bonfire/pubspec_checker/issues">Issues</a> •
  <a href="https://github.com/marianz-bonfire/pubspec_checker/tree/master/example">Example</a> •
  <a href="https://github.com/marianz-bonfire/pubspec_checker/blob/master/LICENSE">License</a> •
  <a href="https://pub.dev/packages/pubspec_checker">Pub.dev</a>
</p>

A simple Dart/Flutter package that checks the compatibility of all dependencies in the `pubspec.yaml` file for specified platforms. This package reads the `pubspec.yaml` file, fetches the package information from `pub.dev`, and verifies the platforms (like `Android`, `iOS`, `web`, `macOS`, `Windows`, and `Linux`) against the provided list.
<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

<img src="https://raw.githubusercontent.com/marianz-bonfire/pubspec_checker/master/assets/demo-cli.png">


## ✨ Features

### 🎯 **Platform Compatibility Checking**
- Check package compatibility across **6 platforms**: Android, iOS, Web, Windows, macOS, Linux
- Specify platforms via command-line or programmatic API
- Multi-platform support with a single command

### 📊 **Detailed Reporting & Visualization**
- **Tabular format** for clean, structured output that's easy to read and compare
- **Color-coded status indicators** for instant visual recognition
- **Optional package links** to pub.dev for quick reference
- **Summary statistics** showing support counts per platform
- **Unknown package detection** with clear warnings

### 🎨 **Flexible Display Options**
- **Icon mode**: Use emoji icons (✅ ❌ ❔) for visual clarity
- **ASCII mode**: Use plain characters (`Y`, `N`, `?`) for terminal compatibility
- **Link display**: Show/hide package links to pub.dev
- **Progress indicators**: Real-time progress during compatibility checks

### ⚡ **Easy Integration**
- **Command-line interface**: Quick one-liner checks
- **Programmatic API**: Integrate into your own tools and workflows
- **Automatic pubspec detection**: Automatically finds your `pubspec.yaml`
- **Multiple fallback strategies**: Uses 4 different methods to gather platform data

## 🚀 Quick Start

### Installation

Add `pubspec_checker` to your Flutter or Dart project:

```yaml
dev_dependencies:
  pubspec_checker: ^1.3.0
```
Run this command:
```bash
flutter pub get
# or
dart pub get
```

## 📒 Basic CLI Usage

Command-Line Interface (CLI)
To use the package, run the following command:

```bash
dart run pubspec_checker <platforms> [options]
```
_Parameters_
- `<platforms>`: The platforms to check compatibility for. Supported values are:
    - android
    - ios
    - web
    - windows
    - linux
    - macos

_Options_
- `-s` or `--show`: Display the platform status indicator as icon (e.g. Supported : ✅ ❌ ❔, otherwise the default `Y`, `N`, `?`).
- `-l` or `--links`: Display the links to the package details.

## 📚 Examples
Check compatibility for `all` platforms with links and show icons:

```bash
dart run pubspec_checker -s -l
//or
dart run pubspec_checker all -s -l
```

Check compatibility for `android` and `ios`:

```bash
dart run pubspec_checker android ios -s -l
```
Check compatibility for `android` and `ios` and shows package link:
```bash
dart run pubspec_checker android ios -l
```
Check compatibility for `web`:
```bash
dart run pubspec_checker web
dart run pubspec_checker:web #alternative command with colon
```

Example output showing status platform as icon (`-s`):
```bash
dart run pubspec_checker -l -s
```
<img src="https://raw.githubusercontent.com/marianz-bonfire/pubspec_checker/master/assets/demo-cli-icon.png">

Example output showing status platform by default (_without_ `-s`):
```bash
dart run pubspec_checker -l
```

<img src="https://raw.githubusercontent.com/marianz-bonfire/pubspec_checker/master/assets/demo-cli-default.png">

NOTE: 📝 By default we use ASCII characters (e.g., `Y`, `N`, `?`) on platform status indicator to ensure proper alignment across different terminals such: (_Command Prompt, PowerShell, Linux Terminal, Git Bash_, etc). Emojis like ✅, ❌, and ❔ can sometimes have variable widths depending on the terminal or font.

## 💡 Additional information

If you want to use the package programmatically, here’s how you can do it:

```dart
import 'package:pubspec_checker/pubspec_checker.dart';

void main() async {
  // Initialize with target platforms
  final platformChecker = PlatformChecker([
    PackagePlatform.ios,
    PackagePlatform.android
  ]);

  // Read dependencies from pubspec.yaml
  final pubspecReader = PubspecReader();
  final dependencies = pubspecReader.getDependencies();

  // Check compatibility
  final results = await platformChecker.checkDependenciesCompatibility(dependencies);

  // Process results
  for (final entry in results.entries) {
    final packageName = entry.key;
    final compatibility = entry.value;

    print('Package: $packageName');
    print('Version: ${compatibility.version}');
    print('Supported Platforms: ${compatibility.platforms.map((p) => p.platformName).join(', ')}');
    print('Link: ${compatibility.link}');
  }
}
```
If you want simply check the list of packages not the dependencies.
```dart
import 'package:pubspec_checker/pubspec_checker.dart';

void main() async {
  // Initialize with target platforms
  final platformChecker = PlatformChecker([
    PackagePlatform.ios,
    PackagePlatform.android
  ]);
  
  // Check compatibility of the packages
  final results = await platformChecker.checkPackagesCompatibility([
    'provider',
    'http',
    'flutter_bloc',
  ]);

  // Process results
  for (final entry in results.entries) {
    final packageName = entry.key;
    final compatibility = entry.value;

    print('Package: $packageName');
    print('Version: ${compatibility.version}');
    print('Supported Platforms: ${compatibility.platforms.map((p) => p.platformName).join(', ')}');
    print('Link: ${compatibility.link}');
  }
}
```
 *Notes*

- Platforms are provided using the `PackagePlatform` enum for compile-time safety.
- Public APIs are documented with examples, while internal implementations are hidden from API docs.
- When using the package programmatically, add it under `dependencies`, not `dev_dependencies`.


Sample Output:

<img src="https://raw.githubusercontent.com/marianz-bonfire/pubspec_checker/master/assets/demo-example.png">

## 🔧 How It Works
### Platform Detection Strategies
`pubspec_checker` uses multiple methods to determine platform compatibility:
1. Primary: Direct pubspec metadata from pub.dev API
2. Fallback 1: Package score tags (platform:xxx tags)
3. Fallback 2: Search-based platform detection
4. Fallback 3: Web scraping of package pages

This multi-layered approach ensures maximum accuracy even when platform data is incomplete.

### Architecture
- [`PubspecReader`](https://pub.dev/documentation/pubspec_checker/latest/pubspec_checker/PubspecReader-class.html): Parses pubspec.yaml and extracts dependencies
- [`PlatformChecker`](https://pub.dev/documentation/pubspec_checker/latest/pubspec_checker/PlatformChecker-class.html): Queries pub.dev APIs and analyzes platform support
- [`PackageChecker`](https://pub.dev/documentation/pubspec_checker/latest/pubspec_checker/PackageChecker-class.html): High-level API with formatted console output
- [`PackageCompatibility`](https://pub.dev/documentation/pubspec_checker/latest/pubspec_checker/PackageCompatibility-class.html): Data model for compatibility results

## 🐞 Contributing
Contributions are welcome! If you encounter any issues or have feature requests, please open an issue or submit a pull request on [GitHub](https://github.com/marianz-bonfire/pubspec_checker).

## 🎖️ License
This package is licensed under the [MIT License](https://mit-license.org/).

