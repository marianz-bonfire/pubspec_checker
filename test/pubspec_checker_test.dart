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
}
