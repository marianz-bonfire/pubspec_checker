import 'package:args/args.dart';
import 'package:pubspec_checker/pubspec_checker.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('show',
        abbr: 's', negatable: false, help: 'Show platform status as icon')
    ..addFlag('links',
        abbr: 'l', negatable: false, help: 'Show links of packages');

  // Parse the arguments
  final results = parser.parse(arguments);

  // Extract platforms to be checked (positional arguments)
  final platformsToCheck = results.rest; // Remaining arguments after options
  final showIcon = results['show'] as bool; // Check if -s is provided
  final showLinks = results['links'] as bool; // Check if -l is provided

  List<PackagePlatform> platforms =
      PackagePlatform.values.map((platform) => platform).toList();
  if (platformsToCheck.isNotEmpty) {
    // Filtered only available platforms
    List<PackagePlatform> allPlatforms = PackagePlatform.values
        .where((platform) => platformsToCheck.contains('all'))
        .toList();
    if (allPlatforms.isEmpty) {
      platforms = PackagePlatform.values
          .where((platform) => platformsToCheck.contains(platform.platformName))
          .toList();
    }
  }
  await PackageChecker()
      .checkAll(platforms, showLink: showLinks, showIcon: showIcon);
}
