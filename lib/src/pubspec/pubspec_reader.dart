import 'package:yaml/yaml.dart';
import 'pubspec_loader.dart';

/// A utility class for reading and parsing dependencies from `pubspec.yaml`.
///
/// This class provides a simple interface to extract dependency information
/// from a Flutter/Dart project's `pubspec.yaml` file. It works in conjunction
/// with PubspecLoader to locate and load the configuration file.
///
/// ## Usage
///
/// ```dart
/// import 'package:pubspec_checker/pubspec_checker.dart';
///
/// void main() {
///   // Create a PubspecReader instance
///   final reader = PubspecReader();
///
///   // Read dependencies from pubspec.yaml
///   final dependencies = reader.getDependencies();
///
///   // Process the dependencies
///   print('Found ${dependencies.length} dependencies:');
///   dependencies.forEach((package, version) {
///     print('  $package: $version');
///   });
/// }
/// ```
///
/// ## Output Example
///
/// ```dart
/// // Sample dependencies map returned by getDependencies()
/// {
///   'provider': '^6.0.0',
///   'http': '^1.0.0',
///   'flutter_bloc': '^8.0.0',
///   'dio': '^5.0.0',
///   'intl': '^0.18.0',
/// }
/// ```
///
/// ## File Location
///
/// The reader automatically looks for `pubspec.yaml` in:
/// 1. The current working directory
/// 2. Parent directories (up to 3 levels up)
/// 3. The standard Flutter project location
///
/// ## Notes
///
/// - Returns an empty map if no dependencies are found
/// - Handles both simple version strings and complex version constraints
/// - Works with Dart projects as well as Flutter projects
/// - Throws exceptions if `pubspec.yaml` cannot be found or parsed
///
/// ## Integration with PlatformChecker
///
/// This class is typically used in conjunction with [PlatformChecker]:
///
/// ```dart
/// final reader = PubspecReader();
/// final dependencies = reader.getDependencies();
///
/// final checker = PlatformChecker([
///   PackagePlatform.android,
///   PackagePlatform.ios,
/// ]);
///
/// final compatibility = await checker.checkDependenciesCompatibility(
///   dependencies,
/// );
/// ```
class PubspecReader {
  /// Reads and parses the dependencies section from the `pubspec.yaml` file.
  ///
  /// This method locates the `pubspec.yaml` file, loads its content,
  /// parses the YAML structure, and extracts the `dependencies` section.
  ///
  /// ## Return Value
  ///
  /// Returns a `Map<String, dynamic>` where:
  /// - **Keys** are package names (e.g., `'provider'`, `'http'`)
  /// - **Values** are version constraints which can be:
  ///   - Simple version strings (e.g., `'^6.0.0'`)
  ///   - Complex dependency specifications
  ///   - Git references or path dependencies
  ///
  /// ## Example Output
  ///
  /// ```dart
  /// {
  ///   'flutter': '>=3.0.0 <4.0.0',
  ///   'provider': '^6.0.0',
  ///   'http': {
  ///     'version': '^1.0.0',
  ///     'git': {
  ///       'url': 'https://github.com/dart-lang/http.git',
  ///       'ref': 'master'
  ///     }
  ///   },
  ///   'local_package': {
  ///     'path': '../local_package'
  ///   }
  /// }
  /// ```
  ///
  /// ## Error Handling
  ///
  /// - Returns an empty map `{}` if the `dependencies` section is missing
  /// - Throws [YamlException] if the YAML content is malformed
  ///
  /// ## Example
  ///
  /// ```dart
  /// final reader = PubspecReader();
  ///
  /// try {
  ///   final dependencies = reader.getDependencies();
  ///
  ///   if (dependencies.isEmpty) {
  ///     print('No dependencies found in pubspec.yaml');
  ///   } else {
  ///     // Filter for regular package dependencies (excluding Flutter SDK)
  ///     final packageDeps = dependencies.entries.where((entry) {
  ///       return entry.key != 'flutter' &&
  ///              (entry.value is String || entry.value is Map);
  ///     }).toList();
  ///
  ///     print('Found ${packageDeps.length} package dependencies');
  ///   }
  /// } catch (e) {
  ///   print('Error reading pubspec.yaml: $e');
  /// }
  /// ```
  Map<String, dynamic> getDependencies() {
    return _getDependenciesImpl();
  }

  // Hidden implementation
  Map<String, dynamic> _getDependenciesImpl() {
    final content = loadPubspecYaml();
    final yaml = loadYaml(content) as YamlMap;

    return yaml['dependencies']?.cast<String, dynamic>() ?? {};
  }
}
