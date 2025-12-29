import 'package:pubspec_checker/pubspec_checker.dart';
import 'package:test/test.dart';

void main() {
  group('Checking', () {
    List<PackagePlatform> platforms = [];

    setUp(() {
      platforms = [
        PackagePlatform.android,
        PackagePlatform.ios,
        PackagePlatform.web,
        PackagePlatform.linux,
        PackagePlatform.windows,
        PackagePlatform.macos
      ];
    });

    test('"All Platforms" package compatibility', () async {
      await PackageChecker().checkAll(platforms, showLink: true);
    });

    test('compatibility packages', () async {
      // Instantiate a PubspecReader to read dependencies.
      final reader = PubspecReader();

      // Instantiate a PlatformChecker for specific platforms.
      final checker =
          PlatformChecker([PackagePlatform.ios, PackagePlatform.android]);

      // Get dependencies from pubspec.yaml.
      final dependencies = reader.getDependencies();

      // Check compatibility for the dependencies.
      final compatibility =
          await checker.checkDependenciesCompatibility(dependencies);

      // Print the results for verification.
      for (final entry in compatibility.entries) {
        print('Package: ${entry.key}, Platforms: ${entry.value}');
      }

      // Example assertion to ensure the test passes.
      expect(compatibility.isNotEmpty, true);
    });
  });
}
