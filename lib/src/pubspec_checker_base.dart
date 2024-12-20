// Provides the primary logic for the pubspec_checker package.
// This file contains public-facing classes and methods for checking platform compatibility.

import 'package:pubspec_checker/pubspec_checker.dart';
import 'package:pubspec_checker/src/constants.dart';

/// A class to check the compatibility of packages with specified platforms.
class PackageChecker {
  /// Checks compatibility for a single [PackagePlatform].
  ///
  /// Iterates through the specified platform, fetches its name, and validates the packages.
  Future<void> checkPlatform(PackagePlatform platform) async {
    var checkedPlatforms = platforms.where((element) => element['id'] == platform);
    var platformNames = checkedPlatforms.map((platform) => platform['name'] as String).toList();
    for (var element in platformNames) {
      check(element);
    }
  }

  /// Checks compatibility for a single platform by its [platformName].
  ///
  /// - [platformName]: The name of the platform (e.g., "android", "ios").
  /// - [showLink]: If true, includes links to package details in the output.

  Future<void> check(String platformName, {bool showLink = false}) async {
    // Log the start of the compatibility check.
    var logPrinter = LogPrintHelper();
    logPrinter.printStart(platformName);

    // Initialize the pubspec reader and platform checker.
    final reader = PubspecReader();
    final checker = PlatformChecker([platformName]);

    // Get the dependencies from pubspec.yaml.
    final dependencies = reader.getDependencies();

    // Check the compatibility of dependencies with the platform.
    final compatibility = await checker.checkPackageCompatibility(dependencies);
    if (compatibility.entries.isEmpty) {
      print('$red No package(s) found in pubspec.yaml$reset');
      return;
    }

    // Lists to track supported and unsupported packages.
    List<String> supportedList = [];
    List<String> notSupportedList = [];

    // Categorize packages based on compatibility.
    for (final entry in compatibility.entries) {
      if (entry.value.isNotEmpty) {
        if (checker.isCompatible(entry.value)) {
          supportedList.add(entry.key);
        } else {
          notSupportedList.add(entry.key);
        }
      }
    }

    // Display supported packages.
    if (supportedList.isNotEmpty) {
      print('$blue(${supportedList.length})$green Supported:$reset');
      for (var package in supportedList) {
        print('  ✅  $package');
      }
    }

    // Display unsupported packages.
    if (notSupportedList.isNotEmpty) {
      print('$blue(${notSupportedList.length})$red Not Supported:$reset');
      for (var package in notSupportedList) {
        print('  ❌  $package');
      }
    }

    // Log the end of the compatibility check.
    logPrinter.printEnd(platformName);
  }

  /// Checks compatibility for all provided [platformNames].
  ///
  /// - [platformNames]: A list of platform names to validate (e.g., ["android", "ios"]).

  Future<void> checkAll(List<String> platformNames) async {
    var logPrinter = LogPrintHelper();

    // Initialize the pubspec reader and platform checker.
    final reader = PubspecReader();
    final checker = PlatformChecker(platformNames);

    final dependencies = reader.getDependencies();
    final compatibility = await checker.checkPackageCompatibility(dependencies);
    if (compatibility.entries.isEmpty) {
      print('$red No package(s) found in pubspec.yaml$reset');
      return;
    }

    List<String> supportedList = [];
    List<String> notSupportedList = [];
    for (final entry in compatibility.entries) {
      if (entry.value.isNotEmpty) {
        if (checker.isCompatible(entry.value)) {
          supportedList.add(entry.key);
          print('  $yellow${entry.key} $green ${entry.value}$reset');
        } else {
          notSupportedList.add(entry.key);
          print('  $yellow${entry.key} $red ${entry.value}$reset');
        }
      }
    }

    print('');
    print('$blue${supportedList.length}$reset$green packages supports$reset');
    print('$blue${notSupportedList.length}$reset$red packages doesn\'t support$reset');
    print('$yellow${'-' * 15} Compatibility check completed for "$platformNames" ${'-' * 15} $reset');
  }
}
