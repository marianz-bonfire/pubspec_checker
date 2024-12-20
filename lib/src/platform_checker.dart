import 'dart:convert';
import 'package:http/http.dart' as http;

class PlatformChecker {
  final List<String> platforms;

  PlatformChecker(this.platforms);

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

        compatibility[package] = supportedPlatforms;
      } else {
        compatibility[package] = ['unknown'];
      }
    }

    return compatibility;
  }

  bool isCompatible(List<String> packagePlatforms) {
    return packagePlatforms.any((platform) => platforms.contains(platform));
  }
}
