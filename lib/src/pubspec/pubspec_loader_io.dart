import 'dart:io';

String loadPubspecYaml([String path = 'pubspec.yaml']) {
  final file = File(path);

  if (!file.existsSync()) {
    throw FileSystemException(
      'pubspec.yaml not found in the project directory.',
    );
  }

  return file.readAsStringSync();
}
