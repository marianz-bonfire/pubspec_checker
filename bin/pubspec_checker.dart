import 'package:args/args.dart';
import 'package:pubspec_checker/pubspec_checker.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('show',
        abbr: 's',
        negatable: false,
        help: 'Show list of packages with supported platforms')
    ..addFlag('links',
        abbr: 'l', negatable: false, help: 'Show links of packages');

  // Parse the arguments
  final results = parser.parse(arguments);

  // Extract platforms to be checked (positional arguments)
  final platformsToCheck = results.rest; // Remaining arguments after options
  final showList = results['show'] as bool; // Check if -s is provided
  final showLinks = results['links'] as bool; // Check if -l is provided

  // Output the parsed arguments
  /*
  print('Platforms to check: $platformsToCheck');
  print('Show list of packages: $showList');
  print('Show links of packages: $showLinks');
   */

  List<String> platformNames =
      platforms.map((platform) => platform['name'] as String).toList();
  if (platformsToCheck.isNotEmpty) {
    // Filtered only available platforms
    List<Map<String, dynamic>> filteredPlatforms = platforms
        .where((platform) => platformsToCheck.contains(platform['name']))
        .toList();

    platformNames = filteredPlatforms
        .map((platform) => platform['name'] as String)
        .toList();
  }
  if (showList) {
    await PackageChecker().checkAll(platformNames, showLink: showLinks);
  } else {
    for (var element in platformNames) {
      await PackageChecker().check(element, showLink: showLinks);
    }
  }
}
