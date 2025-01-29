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
  final showIcon = results['show'] as bool; // Check if -s is provided
  final showLinks = results['links'] as bool; // Check if -l is provided

  await PackageChecker().checkAll([PackagePlatform.ios.name],
      showLink: showLinks, showIcon: showIcon);
}
