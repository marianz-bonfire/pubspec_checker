import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

/// A utility class to check platform compatibility for packages.
class PlatformChecker {
  /// List of platforms to check compatibility against (e.g., `android`, `ios`).
  final List<String> platforms;

  /// Constructor for PlatformChecker.
  /// Accepts a list of platforms to validate against.
  PlatformChecker(this.platforms);

  /// Fetches platform compatibility, version, and link information for a list of packages.
  ///
  /// Takes a `Map<String, dynamic>` of dependencies and returns a map where:
  /// - Keys are package names.
  /// - Values are maps containing:
  ///   - `platforms`: A list of supported platforms.
  ///   - `version`: The latest version of the package.
  ///   - `link`: The package's pub.dev URL.
  Future<Map<String, Map<String, dynamic>>> checkPackageCompatibility(
      Map<String, dynamic> dependencies) async {
    final Map<String, Map<String, dynamic>> compatibility = {};

    try {
      for (final package in dependencies.keys) {
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
            supportedPlatforms = await getScoreSupportedPlatforms(package);
          }

          if (supportedPlatforms.isEmpty) {
            // If platforms is not specified in the pubspec then we will find another way
            // to get the supported platforms by search platform and package name
            supportedPlatforms = await searchSupportedPlatforms(package);
          }

          if (supportedPlatforms.isEmpty) {
            // If platforms is not specified in the pub dev search then we need
            // to crawl the package website page to get the supported platforms
            supportedPlatforms = await scrapSupportedPlatforms(package);
          }

          // Store the supported platforms for the package.
          compatibility[package] = {
            'platforms': supportedPlatforms,
            'version': version,
            'link': link,
          };
        } else {
          // If the package is not found, mark its platform and version as 'unknown'.
          compatibility[package] = {
            'platforms': ['unknown'],
            'version': 'unknown',
            'link': 'unknown',
          };
        }
      }
    } catch (e) {
      rethrow;
    }

    return compatibility;
  }

  Future<List<String>> getScoreSupportedPlatforms(String packageName) async {
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

  Future<List<String>> searchSupportedPlatforms(String packageName) async {
    List<String> supportedPlatforms = [];
    for (var platformName in platforms) {
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

  Future<List<String>> scrapSupportedPlatforms(String packageName) async {
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

  /// Checks if a package's platforms are compatible with the provided platform list.
  ///
  /// Returns `true` if there is at least one matching platform; otherwise, `false`.
  bool isCompatible(List<String> packagePlatforms) {
    return packagePlatforms.any((platform) => platforms.contains(platform));
  }
}
