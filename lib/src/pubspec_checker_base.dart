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
    var checkedPlatforms =
        platforms.where((element) => element['id'] == platform);
    var platformNames =
        checkedPlatforms.map((platform) => platform['name'] as String).toList();
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
    List<MapEntry<String, Map<String, dynamic>>> unknownList = [];

    int maxWidth = compatibility.entries
        .map((pkg) => pkg.key.length)
        .reduce((a, b) => a > b ? a : b);
    // Categorize packages based on compatibility.
    for (final entry in compatibility.entries) {
      var supportedPlatforms = entry.value['platforms'];

      if (supportedPlatforms.isNotEmpty) {
        if (checker.isCompatible(supportedPlatforms)) {
          supportedList.add(entry.key);
        } else {
          notSupportedList.add(entry.key);
        }
      } else {
        unknownList.add(entry);
      }
    }

    // Display supported packages.
    if (supportedList.isNotEmpty) {
      print('$blue(${supportedList.length})$green Supported:$reset');
      for (var package in supportedList) {
        print(
            '  ✅  ${package.padRight(maxWidth)} ${showLink ? 'https://pub.dev/packages/$package' : ''}');
      }
    }

    // Display unsupported packages.
    if (notSupportedList.isNotEmpty) {
      print('$blue(${notSupportedList.length})$red Not Supported:$reset');
      for (var package in notSupportedList) {
        print(
            '  ❌  ${package.padRight(maxWidth)} ${showLink ? 'https://pub.dev/packages/$package' : ''}');
      }
    }

    // Display unknown packages.
    if (unknownList.isNotEmpty) {
      print('$blue(${unknownList.length})$yellow Unknown:$reset');
      for (var package in unknownList) {
        print(
            '  ❓  ${package.key.padRight(maxWidth)} ${showLink ? 'https://pub.dev/packages/${package.key}' : ''}');
      }
    }

    // Log the end of the compatibility check.
    logPrinter.printEnd(platformName);
  }

  /// Checks compatibility for all provided [platformNames].
  ///
  /// - [platformNames]: A list of platform names to validate (e.g., ["android", "ios"]).

  Future<void> checkAll(List<String> platformNames,
      {bool showLink = false}) async {
    var logPrinter = LogPrintHelper(maxLength: 100);
    logPrinter.printStart(platformNames.join(', '));

    // Initialize the pubspec reader and platform checker.
    final reader = PubspecReader();
    final checker = PlatformChecker(platformNames);

    final dependencies = reader.getDependencies();
    final compatibility = await checker.checkPackageCompatibility(dependencies);
    if (compatibility.entries.isEmpty) {
      print('$red No package(s) found in pubspec.yaml$reset');
      return;
    }

    List<MapEntry<String, Map<String, dynamic>>> supportedList = [];
    List<MapEntry<String, Map<String, dynamic>>> notSupportedList = [];
    List<MapEntry<String, Map<String, dynamic>>> unknownList = [];

    // Determine the maximum width for the first column
    int maxWidth = compatibility.entries
        .map((pkg) => pkg.key.length)
        .reduce((a, b) => a > b ? a : b);

    int maxPlatformsWidth = compatibility.entries
        .map((pkg) => pkg.value['platforms'].toString().length)
        .reduce((a, b) => a > b ? a : b);

    for (final entry in compatibility.entries) {
      var supportedPlatforms = entry.value['platforms'];
      if (supportedPlatforms.isNotEmpty) {
        if (checker.isCompatible(supportedPlatforms)) {
          supportedList.add(entry);
        } else {
          notSupportedList.add(entry);
        }
      } else {
        unknownList.add(entry);
      }
    }

    // Display supported packages.
    if (supportedList.isNotEmpty) {
      for (var package in supportedList) {
        var link = showLink ? 'https://pub.dev/packages/${package.key}' : '';
        var supportedPlatformNames = package.value['platforms'].toString();
        print(
            '$green ✅ ${package.key.padRight(maxWidth)}\t${supportedPlatformNames.padRight(maxPlatformsWidth)}\t$link$reset');
      }
    }

    // Display unsupported packages.
    if (notSupportedList.isNotEmpty) {
      for (var package in notSupportedList) {
        var link = showLink ? 'https://pub.dev/packages/${package.key}' : '';
        var supportedPlatformNames = package.value['platforms'].toString();
        print(
            '$red ❌ ${package.key.padRight(maxWidth)}\t${supportedPlatformNames.padRight(maxPlatformsWidth)}\t$link$reset');
      }
    }

    // Display unknown packages.
    if (unknownList.isNotEmpty) {
      for (var package in unknownList) {
        var link = showLink ? 'https://pub.dev/packages/${package.key}' : '';
        var supportedPlatformNames = package.value['platforms'].toString();
        print(
            '$yellow ❓ ${package.key.padRight(maxWidth)}\t${'[unknown]'.padRight(maxPlatformsWidth)}\t$link$reset');
      }
    }

    print('');
    print('$blue${supportedList.length}$reset$green packages supports$reset');
    print(
        '$blue${notSupportedList.length}$reset$red packages doesn\'t support$reset');
    print(
        '$blue${unknownList.length}$reset$yellow unknown packages, you need to check it manually in the link$reset');

    // Log the end of the compatibility check.
    logPrinter.printEnd(platformNames.join(', '));
  }
}
