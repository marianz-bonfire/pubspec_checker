import 'dart:convert';
import 'package:http/http.dart' as http;

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

    int index = 0;
    for (final package in dependencies.keys) {
      final url = Uri.parse('https://pub.dev/api/packages/$package');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (index == 0) {
          //print(response.body);
        }
        final data = jsonDecode(response.body);
        final supportedPlatforms = (data['latest']['pubspec']['flutter']
                    ?['plugin']?['platforms'] as Map?)
                ?.keys
                .map((value) => '$value')
                .toList() ??
            [];

        // Extract version and link
        final version = data['latest']['version'] as String;
        final link = data['latest']['archive_url'] as String;

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
      index++;
    }

    return compatibility;
  }

  /// Checks if a package's platforms are compatible with the provided platform list.
  ///
  /// Returns `true` if there is at least one matching platform; otherwise, `false`.
  bool isCompatible(List<String> packagePlatforms) {
    return packagePlatforms.any((platform) => platforms.contains(platform));
  }
}
