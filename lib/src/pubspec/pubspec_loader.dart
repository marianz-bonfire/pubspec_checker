export 'pubspec_loader_stub.dart'
    if (dart.library.io) 'pubspec_loader_io.dart'
    if (dart.library.js_interop) 'pubspec_loader_web.dart';
