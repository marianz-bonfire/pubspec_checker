String loadPubspecYaml([String path = 'pubspec.yaml']) {
  throw UnsupportedError(
    'Reading pubspec.yaml from the local file system '
    'is not supported on Web. '
    'Provide the content manually or via HTTP.',
  );
}
