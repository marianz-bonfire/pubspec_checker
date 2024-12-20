import 'dart:io';

import 'package:yaml/yaml.dart';

/// A utility class to read and parse the pubspec.yaml file.
class PubspecReader {
  /// The path to the pubspec.yaml file.
  final File pubspecFile;

  /// Constructor for PubspecReader.
  /// If no path is provided, it defaults to the current directory's pubspec.yaml
  PubspecReader([String path = 'pubspec.yaml']) : pubspecFile = File(path);

  /// Reads and parses the dependencies from the pubspec.yaml file.
  ///
  /// Returns a `Map<String, dynamic>` containing the dependencies.
  /// Throws a `FileSystemException` if the file does not exist.
  Map<String, dynamic> getDependencies() {
    if (!pubspecFile.existsSync()) {
      throw FileSystemException('pubspec.yaml not found in the project directory.');
    }

    final content = pubspecFile.readAsStringSync();
    final yaml = loadYaml(content) as Map;

    // Extracts and returns the dependencies section from the YAML file.
    return yaml['dependencies']?.cast<String, dynamic>() ?? {};
  }
}
