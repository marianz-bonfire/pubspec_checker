// TODO: Put public facing types in this file.

import 'package:pubspec_checker/pubspec_checker.dart';
import 'package:pubspec_checker/src/constants.dart';

class PackageChecker {
  Future<void> checkPlatform(PackagePlatform platform) async {
    var checkedPlatforms = platforms.where((element) => element['id'] == platform);
    var platformNames = checkedPlatforms.map((platform) => platform['name'] as String).toList();
    for (var element in platformNames) {
      check(element);
    }
  }

  Future<void> check(String platformName, {bool showLink = false}) async {
    var logPrinter = LogPrintHelper();
    logPrinter.printStart(platformName);
    final reader = PubspecReader();
    final checker = PlatformChecker([platformName]);

    final dependencies = reader.getDependencies();
    final compatibility = await checker.checkPackageCompatibility(dependencies);
    if (compatibility.entries.isEmpty) {
      print('$red No package(s) found in pubspec.yaml$reset');
      return;
    }

    List<String> supportedList = [];
    List<String> notSupportedList = [];
    for (final entry in compatibility.entries) {
      if (entry.value.isNotEmpty) {
        if (checker.isCompatible(entry.value)) {
          supportedList.add(entry.key);
        } else {
          notSupportedList.add(entry.key);
        }
      }
    }

    if (supportedList.isNotEmpty) {
      print('$blue(${supportedList.length})$green Supported:$reset');
      for (var package in supportedList) {
        print('  ✅  $package');
      }
    }

    if (notSupportedList.isNotEmpty) {
      print('$blue(${notSupportedList.length})$red Not Supported:$reset');
      for (var package in notSupportedList) {
        print('  ❌  $package');
      }
    }
    logPrinter.printEnd(platformName);
  }

  Future<void> checkAll(List<String> platformNames) async {
    var logPrinter = LogPrintHelper();
    final reader = PubspecReader();
    final checker = PlatformChecker(platformNames);

    final dependencies = reader.getDependencies();
    final compatibility = await checker.checkPackageCompatibility(dependencies);
    if (compatibility.entries.isEmpty) {
      print('$red No package(s) found in pubspec.yaml$reset');
      return;
    }

    List<String> supportedList = [];
    List<String> notSupportedList = [];
    for (final entry in compatibility.entries) {
      if (entry.value.isNotEmpty) {
        if (checker.isCompatible(entry.value)) {
          supportedList.add(entry.key);
          print('  $yellow${entry.key} $green ${entry.value}$reset');
        } else {
          notSupportedList.add(entry.key);
          print('  $yellow${entry.key} $red ${entry.value}$reset');
        }
      }
    }

    print('');
    print('$blue${supportedList.length}$reset$green packages supports$reset');
    print('$blue${notSupportedList.length}$reset$red packages doesn\'t support$reset');
    print('$yellow${'-' * 15} Compatibility check completed for "$platformNames" ${'-' * 15} $reset');
  }
}
