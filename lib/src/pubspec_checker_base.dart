// Provides the primary logic for the pubspec_checker package.
// This file contains public-facing classes and methods for checking platform compatibility.

import 'dart:async';
import 'dart:io';

import 'package:pubspec_checker/pubspec_checker.dart';
import 'package:pubspec_checker/src/constants.dart';

extension StringCenter on String {
  String center(int width) {
    int padding = (width - length) ~/ 2;
    int remainder = (width - length) % 2;
    return ' ' * padding + this + ' ' * (padding + remainder);
  }
}

extension StatusIcon on String {
  String iconStatus(bool showIcon) {
    switch (this) {
      case '✅':
        return showIcon ? '✅' : 'Y';
      case '❌':
        return showIcon ? '❌' : 'N';
      case '❔':
        return showIcon ? '❔' : '?';
      default:
        return this; // Default to the original string if it doesn't match
    }
  }
}

extension StatusLabel on String {
  String labelStatus(bool showIcon) {
    switch (this) {
      case '✅':
        return 'Supported';
      case '❌':
        return 'Not Supported';
      case '❔':
        return 'Unknown';
      default:
        return this; // Default to the original string if it doesn't match
    }
  }
}

extension StatusFormatter on String {
  String statusFormat(bool showIcon) {
    return '${iconStatus(showIcon)} ${labelStatus(showIcon)}';
  }
}

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
    checkAll(platformNames);
  }

  /// Checks compatibility for a single platform by its [platformName].
  ///
  /// - [platformName]: The name of the platform (e.g., "android", "ios").
  /// - [showLink]: If true, includes links to package details in the output.
  /// - [showIcon]: If true, show platform status as icon.

  Future<void> check(String platformName,
      {bool showLink = false, bool showIcon = false}) async {
    checkAll([platformName], showLink: showLink, showIcon: showIcon);
  }

  /// Checks compatibility for all provided [platformNames].
  ///
  /// - [platformNames]: A list of platform names in array form to validate.
  /// - [showLink]: If true, includes links to package details in the output.
  /// - [showIcon]: If true, show platform status as icon.
  Future<void> checkAll(List<String> platformNames,
      {bool showLink = false, bool showIcon = true}) async {
    // Start stopwatch to measure elapsed time
    Stopwatch stopwatch = Stopwatch()..start();

    // Print "Checking..." with elapsed time in seconds
    var timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      stdout.write(
          '\r${blue}Checking compatibility... ($reset${(stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1)}s$blue)$reset');
    });

    // Initialize the pubspec reader and platform checker.
    final reader = PubspecReader();
    final checker = PlatformChecker(platformNames);

    final dependencies = reader.getDependencies();
    final compatibility = await checker.checkPackageCompatibility(dependencies);

    // Stop the stopwatch and the periodic timer
    stopwatch.stop();
    timer.cancel();

    // Clear the "Checking..." line and print the final message
    stdout.write('\r'); // Clear the current line
    //print('\nCompatibility check completed in ${(stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1)}s.');

    if (compatibility.entries.isEmpty) {
      print('$red No package(s) found in pubspec.yaml$reset');
      return;
    }

    List<MapEntry<String, Map<String, dynamic>>> unknownList = [];

    // Determine the maximum width for the first column
    int maxWidth = compatibility.entries
        .map((pkg) => pkg.key.length)
        .reduce((a, b) => a > b ? a : b);

    if (maxWidth < 15) {
      maxWidth = 15;
    }

    int linkWidth = 25 + maxWidth;

    // Header separator width
    int separatorWidth =
        maxWidth + 2 + (platformNames.length * 10) + platformNames.length + 1;
    if (showLink) separatorWidth += linkWidth + 3;
    // Initialize counters for summary
    Map<String, Map<String, int>> platformCounts = {
      for (var platform in platformNames) platform: {'✅': 0, '❌': 0, '❔': 0}
    };

    // Print the header separator
    print('-' * separatorWidth);

    // Print the header row
    String header = 'Package Name'.padRight(maxWidth + 2) +
        platformNames.map((p) => '| ${p.center(8)} ').join();
    if (showLink) header += '| ${'link'.center(linkWidth)} ';
    header += '|';
    print(header);

    // Print another separator
    print('-' * separatorWidth);

    for (final entry in compatibility.entries) {
      List<String> supportedPlatforms = entry.value['platforms'];
      String packageName = entry.key.padRight(maxWidth + 2);

      String color = (supportedPlatforms.isEmpty) ? yellow : '';

      String row = '$color$packageName$reset${platformNames.map((platform) {
        String status = '❔';
        if (supportedPlatforms.isNotEmpty) {
          status = (supportedPlatforms.contains(platform)) ? '✅' : '❌';
          color = (supportedPlatforms.contains(platform)) ? greenBg : redBg;
        } else {
          status = '❔';
          color = yellowBg;
          unknownList.add(entry);
        }
        // Increment the counts for the current platform
        platformCounts[platform]?[status] =
            (platformCounts[platform]?[status] ?? 0) + 1;

        if (showIcon) {
          return '| ${status.center(8)} ';
        } else {
          return '| $color${status.iconStatus(showIcon).center(8)}$reset ';
        }
      }).join()}';
      // Add link column if enabled
      if (showLink) {
        String link = 'https://pub.dev/packages/${entry.key}';
        row += '| ${link.padRight(linkWidth)} ';
      }
      row += '|';
      print(row);
    }

    print('-' * separatorWidth);

    // Print the summary rows
    for (var status in ['✅', '❌', '❔']) {
      String summaryLabel = status.statusFormat(showIcon);
      String color = status == '✅'
          ? green
          : status == '❌'
              ? red
              : yellow;
      String summaryRow =
          '$color${summaryLabel.padRight(maxWidth + 2)}$reset${platformNames.map((platform) {
        int count = platformCounts[platform]?[status] ?? 0;
        String countOf = (count != compatibility.entries.length && count != 0)
            ? '$count/${compatibility.entries.length}'
            : count.toString();
        return '| $color${countOf.center(8)}$reset ';
      }).join()}';

      if (showLink) summaryRow += '| ${''.padRight(linkWidth)} ';
      summaryRow += '|';
      print(summaryRow);
    }

    // Print the final separator
    print('-' * separatorWidth);
    if (unknownList.isNotEmpty) {
      print(
          '$yellow${'❔'.iconStatus(showIcon)}  unknown packages, you need to check it manually in the link$reset');
    }

    // Log the end of the compatibility check.
    print(
        '${blue}Checking compatibility completed in ($reset${(stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1)}s$blue)');
  }
}
