# pubspec_checker
[![Dart CI](https://github.com/marianz-bonfire/pubspec_checker/actions/workflows/dart.yml/badge.svg)](https://github.com/marianz-bonfire/pubspec_checker/actions/workflows/dart.yml)
[![pub package](https://img.shields.io/pub/v/pubspec_checker.svg)](https://pub.dev/packages/pubspec_checker)
[![package publisher](https://img.shields.io/pub/publisher/pubspec_checker.svg)](https://pub.dev/packages/pubspec_checker/publisher)

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
  <a href="https://app.codecov.io/gh/marianz-bonfire/pubspec_checker">
    <img src="https://img.shields.io/codecov/c/github/marianz-bonfire/pubspec_checker?logo=codecov&logoColor=fff&labelColor=333940&flag=pubspec_checker">
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

- Platform Compatibility Check:
    - Specify platforms (e.g., `android`, `ios`, `web`, etc.) to check which packages are supported.
- Detailed Reporting:
    - List all packages with their supported platforms.
Optionally show package links for more details.
- Easy to Use:
     - Command-line arguments for quick execution and flexibility.


## 🚀 Getting started

Add `pubspec_checker` to your Flutter or Dart project:

```yaml
dev_dependencies:
  pubspec_checker: ^1.0.4
```
Run this command:
```bash
flutter pub get
```

## 📒 Usage

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
- `-s` or `--show`: Display the list of packages with their supported platforms.
- `-l` or `--links`: Display the links to the package details.

## 📚 Examples
Check compatibility for `android` and `ios`:

```bash
dart run pubspec_checker android ios
```
Check compatibility for `android` and `ios` and shows package link:
```bash
dart run pubspec_checker android ios -l
```
Check compatibility for `web`:
```bash
dart run pubspec_checker web
```
or
```bash
dart run pubspec_checker:web
```

Example Output:

```bash
PS D:\Repository\pubspec_checker\example> dart run pubspec_checker windows ios
Building package executable...
Built pubspec_checker:pubspec_checker.
------- Started checking compatibility for "windows" -------
(2) Supported:
  ✅  file_picker
  ✅  connectivity_plus
(5) Not Supported:
  ❌  pusher_client
  ❌  disk_space
  ❌  open_file_plus
  ❌  sqflite_sqlcipher
  ❌  flutter_pdfview
------- Compatibility check completed for "windows" --------
```


## 💡 Additional information

If you want to use the package programmatically, here’s how you can do it:

```dart
import 'package:pubspec_checker/pubspec_checker.dart';

void main() async {
  final checker = PlatformChecker(['ios', 'android']);
  final reader = PubspecReader();

  final dependencies = reader.getDependencies();
  final results = await checker.checkPackageCompatibility(dependencies);

  for (var package in results.entries) {
    print('Package: ${package.key}, Supported Platforms: ${package.value['platforms'].join(", ")}');
  }
}
```
_NOTE: Using package in the code, make sure you add it under **pubspec** `dependencies` not in the `dev_dependencies`._

Sample Output:
<img src="https://raw.githubusercontent.com/marianz-bonfire/pubspec_checker/master/assets/demo-example.png">



## 🐞 Contributing
Contributions are welcome! If you encounter any issues or have feature requests, please open an issue or submit a pull request on [GitHub](https://github.com/marianz-bonfire/pubspec_checker).

## 🎖️ License
This package is licensed under the [MIT License](https://mit-license.org/).

