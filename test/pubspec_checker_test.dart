import 'package:pubspec_checker/pubspec_checker.dart';
import 'package:test/test.dart';

void main() {
  group('Checking', () {
    //final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('"android" package compatibility', () async {
      await PackageChecker().checkPlatform(PackagePlatform.android);
    });

    test('"ios" package compatibility', () async {
      await PackageChecker().checkPlatform(PackagePlatform.ios);
    });

    test('"windows" package compatibility', () async {
      await PackageChecker().checkPlatform(PackagePlatform.windows);
    });

    test('"linux" package compatibility', () async {
      await PackageChecker().checkPlatform(PackagePlatform.linux);
    });

    test('"web" package compatibility', () async {
      await PackageChecker().checkPlatform(PackagePlatform.web);
    });
  });

  test('Check package compatibility', () async {
    // Instantiate a PubspecReader to read dependencies.
    final reader = PubspecReader();

    // Instantiate a PlatformChecker for specific platforms.
    final checker = PlatformChecker(['ios', 'android']);

    // Get dependencies from pubspec.yaml.
    final dependencies = reader.getDependencies();

    // Check compatibility for the dependencies.
    final compatibility = await checker.checkPackageCompatibility(dependencies);

    // Print the results for verification.
    for (final entry in compatibility.entries) {
      print('Package: ${entry.key}, Platforms: ${entry.value}');
    }

    // Example assertion to ensure the test passes.
    expect(compatibility.isNotEmpty, true);
  });
}
