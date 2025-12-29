import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:pubspec_checker/pubspec_checker.dart';

/// Represents the compatibility information for a Dart/Flutter package.
///
/// Contains details about supported platforms, version, and pub.dev link
/// for a specific package.
///
/// Example:
/// ```dart
/// final compatibility = PackageCompatibility(
///   platforms: [PackagePlatform.android, PackagePlatform.ios],
///   version: '5.0.0',
///   link: 'https://pub.dev/packages/provider/versions/5.0.0.tar.gz',
/// );
///
/// print(compatibility.platforms.length); // Output: 2
/// print(compatibility.version); // Output: '5.0.0'
/// ```
class PackageCompatibility {
  /// List of platforms supported by this package.
  final List<PackagePlatform> platforms;

  /// The latest version of the package available on pub.dev.
  final String version;

  /// The download link for the package archive on pub.dev.
  final String link;

  /// Creates a [PackageCompatibility] instance.
  ///
  /// - [platforms]: List of supported platforms for the package.
  /// - [version]: Latest version of the package.
  /// - [link]: Download URL for the package archive.
  const PackageCompatibility({
    required this.platforms,
    required this.version,
    required this.link,
  });
}

/// A utility class for checking platform compatibility of Dart/Flutter packages.
///
/// This class queries pub.dev API and web pages to determine which platforms
/// a package supports. It uses multiple fallback strategies to gather
/// platform compatibility information.
///
/// Example:
/// ```dart
/// // Initialize with platforms to check
/// final checker = PlatformChecker([
///   PackagePlatform.android,
///   PackagePlatform.ios,
///   PackagePlatform.web,
/// ]);
///
/// // Check compatibility for specific packages
/// final compatibility = await checker.checkPackagesCompatibility([
///   'provider',
///   'http',
///   'dio',
/// ]);
///
/// // Check if a package is compatible with configured platforms
/// final isCompatible = checker.isCompatible([
///   PackagePlatform.android,
///   PackagePlatform.ios,
/// ]);
/// ```
class PlatformChecker {
  /// List of platforms to check compatibility against.
  ///
  /// Example:
  /// ```dart
  /// final checker = PlatformChecker([
  ///   PackagePlatform.android,
  ///   PackagePlatform.ios,
  ///   PackagePlatform.web,
  /// ]);
  /// ```
  final List<PackagePlatform> platforms;

  /// Creates a [PlatformChecker] instance.
  ///
  /// - [platforms]: The list of platforms to validate package compatibility against.
  PlatformChecker(this.platforms);

  /// Checks platform compatibility for all dependencies from a pubspec.yaml.
  ///
  /// This method takes a dependencies map (typically from `pubspec.yaml`)
  /// and returns compatibility information for each package.
  ///
  /// - [dependencies]: A map of package names to version constraints,
  ///   typically from `pubspec.yaml`.
  ///
  /// Returns a map where:
  /// - Keys are package names
  /// - Values are [PackageCompatibility] objects containing platform support,
  ///   latest version, and download link.
  ///
  /// Example:
  /// ```dart
  /// final dependencies = {
  ///   'provider': '^6.0.0',
  ///   'http': '^1.0.0',
  ///   'dio': '^5.0.0',
  /// };
  ///
  /// final compatibility = await checker.checkDependenciesCompatibility(
  ///   dependencies,
  /// );
  ///
  /// // Access compatibility for a specific package
  /// final providerCompat = compatibility['provider'];
  /// print(providerCompat?.platforms); // [PackagePlatform.android, ...]
  /// ```
  Future<Map<String, PackageCompatibility>> checkDependenciesCompatibility(
      Map<String, dynamic> dependencies) async {
    return _checkDependenciesCompatibilityImpl(dependencies);
  }

  /// Checks platform compatibility for a list of package names.
  ///
  /// This is the primary method for checking multiple packages' compatibility
  /// with the configured platforms. It uses multiple strategies to gather
  /// platform information:
  ///
  /// 1. Direct pubspec metadata from pub.dev API
  /// 2. Package score tags from pub.dev
  /// 3. Search-based platform detection
  /// 4. Web scraping of package pages (fallback)
  ///
  /// - [packages]: List of package names to check.
  ///
  /// Returns a map where:
  /// - Keys are package names
  /// - Values are [PackageCompatibility] objects
  ///
  /// Throws:
  /// - [http.ClientException] if network requests fail
  /// - [FormatException] if API responses are malformed
  ///
  /// Example:
  /// ```dart
  /// final compatibility = await checker.checkPackagesCompatibility([
  ///   'provider',
  ///   'http',
  ///   'flutter_bloc',
  /// ]);
  ///
  /// for (final entry in compatibility.entries) {
  ///   print('${entry.key}: ${entry.value.platforms.length} platforms');
  /// }
  /// ```
  Future<Map<String, PackageCompatibility>> checkPackagesCompatibility(
      List<String> packages) async {
    return _checkPackagesCompatibilityImpl(packages);
  }

  /// Checks if a package's supported platforms are compatible with this checker's configuration.
  ///
  /// Returns `true` if at least one of the package's platforms matches
  /// the platforms configured in this [PlatformChecker] instance.
  ///
  /// - [packagePlatforms]: List of platforms supported by a package.
  ///
  /// Example:
  /// ```dart
  /// final checker = PlatformChecker([PackagePlatform.android]);
  ///
  /// // Package supports android and ios
  /// final packagePlatforms = [
  ///   PackagePlatform.android,
  ///   PackagePlatform.ios,
  /// ];
  ///
  /// final compatible = checker.isCompatible(packagePlatforms);
  /// print(compatible); // Output: true
  ///
  /// // Package supports only web
  /// final webOnlyPlatforms = [PackagePlatform.web];
  /// print(checker.isCompatible(webOnlyPlatforms)); // Output: false
  /// ```
  bool isCompatible(List<PackagePlatform> packagePlatforms) {
    return _isCompatibleImpl(packagePlatforms);
  }

  // Hidden implementation methods
  Future<Map<String, PackageCompatibility>> _checkDependenciesCompatibilityImpl(
      Map<String, dynamic> dependencies) async {
    var packages = dependencies.keys.toList();
    return _checkPackagesCompatibilityImpl(packages);
  }

  Future<Map<String, PackageCompatibility>> _checkPackagesCompatibilityImpl(
      List<String> packages) async {
    // Hidden implementation details
    final Map<String, PackageCompatibility> compatibility = {};

    try {
      for (final package in packages) {
        final url = Uri.parse('https://pub.dev/api/packages/$package');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          List<String> supportedPlatforms = (data['latest']['pubspec']
                      ['flutter']?['plugin']?['platforms'] as Map?)
                  ?.keys
                  .map((value) => '$value')
                  .toList() ??
              [];

          // Extract version and link
          final version = data['latest']['version'] as String;
          final link = data['latest']['archive_url'] as String;

          if (supportedPlatforms.isEmpty) {
            // If platforms is not specified in the pubspec then we will find another way
            // to get the supported platforms by extracting tags on score API
            supportedPlatforms = await _getScoreSupportedPlatforms(package);
          }

          if (supportedPlatforms.isEmpty) {
            // If platforms is not specified in the pubspec then we will find another way
            // to get the supported platforms by search platform and package name
            supportedPlatforms = await _searchSupportedPlatforms(package);
          }

          if (supportedPlatforms.isEmpty) {
            // If platforms is not specified in the pub dev search then we need
            // to crawl the package website page to get the supported platforms
            supportedPlatforms = await _scrapSupportedPlatforms(package);
          }

          final resultPlatforms = PackagePlatform.values
              .where((platform) =>
                  supportedPlatforms.contains(platform.platformName))
              .toList();
          // Store the supported platforms for the package.
          compatibility[package] = PackageCompatibility(
            platforms: resultPlatforms,
            version: version,
            link: link,
          );
        } else {
          // If the package is not found, mark its platform and version as 'unknown'.
          compatibility[package] = const PackageCompatibility(
            platforms: [],
            version: 'unknown',
            link: 'unknown',
          );
        }
      }
    } catch (e) {
      rethrow;
    }

    return compatibility;
  }

  Future<List<String>> _getScoreSupportedPlatforms(String packageName) async {
    // Hidden implementation
    List<String> supportedPlatforms = [];
    try {
      final url = Uri.parse('https://pub.dev/api/packages/$packageName/score');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extract the list of tags
        final tags = List<String>.from(data['tags']);

        // Filter platform tags and remove the "platform:" prefix
        final platforms = tags
            .where((tag) => tag.startsWith('platform:'))
            .map((tag) => tag.replaceFirst('platform:', ''))
            .toList();

        if (platforms.isNotEmpty) {
          for (final platform in platforms) {
            supportedPlatforms.add(platform.trim());
          }
        }
      }
    } catch (_) {}

    return supportedPlatforms;
  }

  Future<List<String>> _searchSupportedPlatforms(String packageName) async {
    // Hidden implementation
    List<String> supportedPlatforms = [];

    var platformNames = platforms.map((p) => p.platformName).toList();

    for (var platformName in platformNames) {
      try {
        final url = Uri.parse(
            'https://pub.dev/api/search?q=platform:$platformName+$packageName');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final packages = data['packages'] as List<dynamic>;
          if (packages.isNotEmpty) {
            final packageExists =
                packages.any((package) => package['package'] == packageName);
            if (packageExists) {
              // The package exists in the list
              supportedPlatforms.add(platformName);
            }
          }
        }
      } catch (_) {}
    }

    return supportedPlatforms;
  }

  Future<List<String>> _scrapSupportedPlatforms(String packageName) async {
    // Hidden implementation
    List<String> supportedPlatforms = [];
    final url = 'https://pub.dev/packages/$packageName';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the HTML content
        final document = parser.parse(response.body);

        // Locate the "Flutter platform support" section
        // Find the 'detail-tags' div
        final detailTagsDiv = document.querySelector('.detail-tags');

        if (detailTagsDiv != null) {
          // Locate 'a' tags inside the div with the Platform span
          final platformLinks = detailTagsDiv
              .querySelectorAll('div.-pub-tag-badge > span.tag-badge-main')
              .where((element) => element.text.trim() == 'Platform')
              .map((element) => element.parent) // Parent of the span
              .expand((parentDiv) =>
                  parentDiv?.querySelectorAll('a.tag-badge-sub') ?? [])
              .map((link) => link.text.trim().toLowerCase())
              .toList()
              .cast<String>(); // Ensure the list is a List<String>

          supportedPlatforms = platformLinks;
        }
      }
    } catch (_) {}
    return supportedPlatforms;
  }

  bool _isCompatibleImpl(List<PackagePlatform> packagePlatforms) {
    return packagePlatforms.any((platform) => platforms.contains(platform));
  }
}
