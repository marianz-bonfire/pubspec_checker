import 'package:pubspec_checker/pubspec_checker.dart';

Future<void> main(List<String> arguments) async {
  await PackageChecker().checkPlatform(PackagePlatform.android);
}
