import 'dart:async';
import 'dart:io';

import 'package:pubspec_checker/pubspec_checker.dart';
import 'package:pubspec_checker/src/console/constants.dart';

/// Enum representing supported platforms for package compatibility checking.
///
/// Each value corresponds to a platform that can be checked for compatibility
/// with Dart/Flutter packages.
///
/// Example:
/// ```dart
/// // Check iOS compatibility
/// final platform = PackagePlatform.ios;
/// print(platform.platformName); // Output: 'ios'
///
/// // Check multiple platforms
/// final platforms = [PackagePlatform.android, PackagePlatform.ios];
/// ```
enum PackagePlatform {
  android('android'),
  ios('ios'),
  windows('windows'),
  macos('macos'),
  linux('linux'),
  web('web');

  /// Platform name as used by pub.dev and package metadata.
  final String platformName;

  const PackagePlatform(this.platformName);
}

/// Enum representing platform compatibility status for a package.
///
/// Used to indicate whether a package supports a specific platform.
///
/// Example:
/// ```dart
/// // Get status display information
/// final status = PlatformStatus.supported;
/// print(status.label()); // Output: 'Supported'
/// print(status.icon(true)); // Output: '✅'
/// ```
enum PlatformStatus { supported, notSupported, unknown }

/// UI helper extensions for [PlatformStatus].
///
/// Provides methods to format platform status for display in console output.
///
/// Example:
/// ```dart
/// final status = PlatformStatus.supported;
/// print(status.format(true)); // Output: '✅ Supported'
/// print(status.format(false)); // Output: 'Y Supported'
/// ```
extension PlatformStatusUi on PlatformStatus {
  /// Returns an icon or character representation of the status.
  ///
  /// - [showIcon]: When true, returns emoji icons. When false, returns single
  ///   character representation.
  ///
  /// Example:
  /// ```dart
  /// PlatformStatus.supported.icon(true); // Returns: '✅'
  /// PlatformStatus.notSupported.icon(false); // Returns: 'N'
  /// PlatformStatus.unknown.icon(true); // Returns: '❔'
  /// ```
  String icon(bool showIcon) => _icon(showIcon);

  /// Returns a human-readable label for the status.
  ///
  /// Example:
  /// ```dart
  /// PlatformStatus.supported.label(); // Returns: 'Supported'
  /// PlatformStatus.notSupported.label(); // Returns: 'Not Supported'
  /// ```
  String label() => _label();

  /// Formats the status with icon and label for display.
  ///
  /// - [showIcon]: Controls whether to include emoji icons in the output.
  ///
  /// Example:
  /// ```dart
  /// PlatformStatus.supported.format(true); // Returns: '✅ Supported'
  /// ```
  String format(bool showIcon) => _format(showIcon);
}

/// Color styling extensions for [PlatformStatus].
///
/// Provides terminal color codes for displaying status in console output.
extension PlatformStatusStyle on PlatformStatus {
  /// Returns the background color code for table display.
  ///
  /// Used when displaying status in table body cells.
  String background() => _background();

  /// Returns the foreground color code for summary display.
  ///
  /// Used when displaying status in summary rows.
  String foreground() => _foreground();
}

/// String helper to center text within a fixed width.
///
/// Example:
/// ```dart
/// 'hello'.center(11); // Returns: '   hello   '
/// 'world'.center(10); // Returns: '  world   '
/// ```
extension StringCenter on String {
  String center(int width) => _center(width);
}

/// A utility class for checking Dart/Flutter package compatibility across platforms.
///
/// This class analyzes dependencies from `pubspec.yaml` and checks their
/// compatibility with specified platforms by querying pub.dev metadata.
///
/// Example:
/// ```dart
/// final checker = PackageChecker();
///
/// // Check a single platform
/// await checker.checkPlatform(
///   PackagePlatform.ios,
///   showLink: true,
///   showIcon: true,
/// );
///
/// // Check multiple platforms
/// await checker.checkAll(
///   [PackagePlatform.android, PackagePlatform.ios, PackagePlatform.web],
///   showLink: false,
/// );
/// ```
class PackageChecker {
  /// Checks package compatibility for a single platform.
  ///
  /// This method analyzes all dependencies in your pubspec.yaml and checks
  /// their compatibility with the specified [platform].
  ///
  /// - [platform]: The platform to check compatibility for.
  /// - [showLink]: If `true`, includes pub.dev package links in the output.
  /// - [showIcon]: If `true`, displays platform status using emoji icons.
  ///
  /// Example:
  /// ```dart
  /// final checker = PackageChecker();
  /// await checker.checkPlatform(
  ///   PackagePlatform.ios,
  ///   showLink: true,
  ///   showIcon: true,
  /// );
  ///
  /// // Sample output:
  /// // ------------------------------------------
  /// // Package Name        |   ios    | link                   |
  /// // ------------------------------------------
  /// // provider           |   ✅     | https://pub.dev/packages/provider |
  /// // http               |   ✅     | https://pub.dev/packages/http     |
  /// // ------------------------------------------
  /// ```
  Future<void> checkPlatform(
    PackagePlatform platform, {
    bool showLink = false,
    bool showIcon = true,
  }) async {
    await _checkPlatformImpl(
      platform,
      showLink: showLink,
      showIcon: showIcon,
    );
  }

  /// Checks package compatibility for multiple platforms.
  ///
  /// Analyzes all dependencies and displays a compatibility table for the
  /// specified [platforms].
  ///
  /// - [platforms]: List of platforms to check compatibility for.
  /// - [showLink]: If `true`, includes pub.dev package links in the output.
  /// - [showIcon]: If `true`, displays platform status using emoji icons.
  ///
  /// Example:
  /// ```dart
  /// final checker = PackageChecker();
  /// await checker.checkAll(
  ///   [PackagePlatform.android, PackagePlatform.ios, PackagePlatform.web],
  ///   showLink: true,
  ///   showIcon: false,
  /// );
  ///
  /// // Sample output:
  /// // ---------------------------------------------------------
  /// // Package Name        | android |   ios    |   web    | link                   |
  /// // ---------------------------------------------------------
  /// // provider           |    Y    |    Y     |    N     | https://pub.dev/packages/provider |
  /// // http               |    Y    |    Y     |    Y     | https://pub.dev/packages/http     |
  /// // ---------------------------------------------------------
  /// // ✅ Supported       |    2    |    2     |    1     |                        |
  /// // ❌ Not Supported   |    0    |    0     |    1     |                        |
  /// // ❔ Unknown         |    0    |    0     |    0     |                        |
  /// // ---------------------------------------------------------
  /// ```
  Future<void> checkAll(
    List<PackagePlatform> platforms, {
    bool showLink = false,
    bool showIcon = true,
  }) async {
    await _checkAllImpl(
      platforms,
      showLink: showLink,
      showIcon: showIcon,
    );
  }

  // Implementation details are hidden from API documentation
  Future<void> _checkPlatformImpl(
    PackagePlatform platform, {
    bool showLink = false,
    bool showIcon = true,
  }) async {
    await _checkAllImpl(
      [platform],
      showLink: showLink,
      showIcon: showIcon,
    );
  }

  Future<void> _checkAllImpl(
    List<PackagePlatform> platforms, {
    bool showLink = false,
    bool showIcon = true,
  }) async {
    // Start stopwatch to measure elapsed time
    final stopwatch = Stopwatch()..start();

    // Print "Checking..." with elapsed time in seconds
    final timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      stdout.write(
        '\r${blue}Checking compatibility... '
        '($reset${(stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1)}s'
        '$blue)$reset',
      );
    });

    // Initialize the pubspec reader and platform checker.
    final reader = PubspecReader();
    final checker = PlatformChecker(platforms);

    final dependencies = reader.getDependencies();
    final compatibility =
        await checker.checkDependenciesCompatibility(dependencies);

    // Stop timers
    stopwatch.stop();
    timer.cancel();
    stdout.write('\r');

    if (compatibility.entries.isEmpty) {
      print('$red No package(s) found in pubspec.yaml$reset');
      return;
    }

    // Track unknown packages
    final List<MapEntry<String, PackageCompatibility>> unknownList = [];

    // Determine column width
    int maxWidth = compatibility.entries
        .map((pkg) => pkg.key.length)
        .reduce((a, b) => a > b ? a : b);

    if (maxWidth < 15) maxWidth = 15;

    final linkWidth = 25 + maxWidth;

    // Header separator width
    int separatorWidth =
        maxWidth + 2 + (platforms.length * 10) + platforms.length + 1;
    if (showLink) separatorWidth += linkWidth + 3;

    // Initialize counters for summary
    final Map<PackagePlatform, Map<PlatformStatus, int>> platformCounts = {
      for (final platform in platforms)
        platform: {
          PlatformStatus.supported: 0,
          PlatformStatus.notSupported: 0,
          PlatformStatus.unknown: 0,
        }
    };

    // Print header
    print('-' * separatorWidth);

    String header = 'Package Name'.padRight(maxWidth + 2) +
        platforms.map((p) => '| ${p.platformName.center(8)} ').join();

    if (showLink) header += '| ${'link'.center(linkWidth)} ';
    header += '|';
    print(header);

    print('-' * separatorWidth);

    // Print rows
    for (final entry in compatibility.entries) {
      final supportedPlatforms = entry.value.platforms;

      final packageName = entry.key.padRight(maxWidth + 2);

      String color = (supportedPlatforms.isEmpty) ? yellow : '';

      String row = '$color$packageName$reset${platforms.map((platform) {
        PlatformStatus status = PlatformStatus.unknown;

        if (supportedPlatforms.isNotEmpty) {
          status = supportedPlatforms.contains(platform)
              ? PlatformStatus.supported
              : PlatformStatus.notSupported;
        } else {
          unknownList.add(entry);
        }

        platformCounts[platform]![status] =
            platformCounts[platform]![status]! + 1;

        final bg = showIcon ? status.foreground() : status.background();
        return '| $bg${status.icon(showIcon).center(8)}$reset ';
      }).join()}';

      if (showLink) {
        final link = 'https://pub.dev/packages/${entry.key}';
        row += '| ${link.padRight(linkWidth)} ';
      }

      row += '|';
      print(row);
    }

    print('-' * separatorWidth);

    // Summary rows
    for (final status in PlatformStatus.values) {
      final color = status.foreground();
      final summaryLabel =
          '$color${status.format(showIcon).padRight(maxWidth + 2)}$reset';

      String summaryRow = summaryLabel +
          platforms.map((platform) {
            final count = platformCounts[platform]![status]!;
            final value = (count != compatibility.entries.length && count != 0)
                ? '$count/${compatibility.entries.length}'
                : count.toString();

            return '| $color${value.center(8)}$reset ';
          }).join();

      if (showLink) {
        summaryRow += '| ${''.padRight(linkWidth)} ';
      }

      summaryRow += '|';
      print(summaryRow);
    }

    print('-' * separatorWidth);

    if (unknownList.isNotEmpty) {
      print(
        '$yellow${PlatformStatus.unknown.icon(showIcon)} '
        'unknown packages, you need to check it manually in the link$reset',
      );
    }

    // Log completion
    print(
      '${blue}Checking compatibility completed in '
      '($reset${(stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1)}s'
      '$blue)$reset',
    );
  }
}

// Hidden implementation extensions
extension _PlatformStatusUiImpl on PlatformStatus {
  String _icon(bool showIcon) => switch (this) {
        PlatformStatus.supported => showIcon ? '✅' : 'Y',
        PlatformStatus.notSupported => showIcon ? '❌' : 'N',
        PlatformStatus.unknown => showIcon ? '❔' : '?',
      };

  String _label() => switch (this) {
        PlatformStatus.supported => 'Supported',
        PlatformStatus.notSupported => 'Not Supported',
        PlatformStatus.unknown => 'Unknown',
      };

  String _format(bool showIcon) => '${_icon(showIcon)} ${_label()}';
}

extension _PlatformStatusStyleImpl on PlatformStatus {
  String _background() => switch (this) {
        PlatformStatus.supported => greenBg,
        PlatformStatus.notSupported => redBg,
        PlatformStatus.unknown => yellowBg,
      };

  String _foreground() => switch (this) {
        PlatformStatus.supported => green,
        PlatformStatus.notSupported => red,
        PlatformStatus.unknown => yellow,
      };
}

extension _StringCenterImpl on String {
  String _center(int width) {
    int padding = (width - length) ~/ 2;
    int remainder = (width - length) % 2;
    return ' ' * padding + this + ' ' * (padding + remainder);
  }
}
