import 'dart:io';

import 'package:yaml/yaml.dart';

class PubspecReader {
  final File pubspecFile;

  PubspecReader([String path = 'pubspec.yaml']) : pubspecFile = File(path);

  Map<String, dynamic> getDependencies() {
    if (!pubspecFile.existsSync()) {
      throw FileSystemException('pubspec.yaml not found in the project directory.');
    }

    final content = pubspecFile.readAsStringSync();
    final yaml = loadYaml(content) as Map;

    return yaml['dependencies']?.cast<String, dynamic>() ?? {};
  }
}
