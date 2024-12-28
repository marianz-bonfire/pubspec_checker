/// Enum representing supported platforms for package compatibility checking.
enum PackagePlatform { android, ios, windows, macos, linux, web }

/// A list of maps defining platform details.
/// Each map contains:
/// - `id`: The unique identifier (enum) for the platform.
/// - `name`: The string representation of the platform name.
List<Map<String, dynamic>> platforms = [
  {'id': PackagePlatform.android, 'name': 'android'},
  {'id': PackagePlatform.ios, 'name': 'ios'},
  {'id': PackagePlatform.macos, 'name': 'macos'},
  {'id': PackagePlatform.windows, 'name': 'windows'},
  {'id': PackagePlatform.linux, 'name': 'linux'},
  {'id': PackagePlatform.web, 'name': 'web'},
];
