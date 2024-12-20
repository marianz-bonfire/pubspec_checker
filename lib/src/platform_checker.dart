import 'dart:convert';
import 'package:http/http.dart' as http;

/// A utility class to check platform compatibility for packages.
class PlatformChecker {
  /// List of platforms to check compatibility against (e.g., `android`, `ios`).
  final List<String> platforms;

  /// Constructor for PlatformChecker.
  /// Accepts a list of platforms to validate against.
  PlatformChecker(this.platforms);

  /// Fetches platform compatibility information for a list of packages.
  ///
  /// Takes a `Map<String, dynamic>` of dependencies and returns a map where:
  /// - Keys are package names.
  /// - Values are a list of supported platforms.
  Future<Map<String, List<String>>> checkPackageCompatibility(Map<String, dynamic> dependencies) async {
    final Map<String, List<String>> compatibility = {};

    for (final package in dependencies.keys) {
      final url = Uri.parse('https://pub.dev/api/packages/$package');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final supportedPlatforms = (data['latest']['pubspec']['flutter']?['plugin']?['platforms'] as Map?)
                ?.keys
                .map((value) => '$value')
                .toList() ??
            [];

        // Store the supported platforms for the package.
        compatibility[package] = supportedPlatforms;
      } else {
        // If the package is not found, mark its platform as 'unknown'.
        compatibility[package] = ['unknown'];
      }
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
