import 'package:flutter/material.dart';
import 'package:pubspec_checker/pubspec_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pubspec Checker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pubspec Checker Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool checking = false;
  Map<String, Map<String, dynamic>> results = {};

  List<String> platformsToCheck = ["windows"];
  PlatformChecker? checker;
  @override
  void initState() {
    super.initState();

    check();
  }

  Future<void> check() async {
    setState(() {
      checking = true;
    });

    checker = PlatformChecker(platformsToCheck);
    final reader = PubspecReader();

    final dependencies = reader.getDependencies();
    results = await checker!.checkPackageCompatibility(dependencies);

    for (var package in results.entries) {
      //print('Package: ${package.key}, Supported Platforms: ${package.value['platforms'].join(", ")}');
    }

    setState(() {
      checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            const Text(
              'Make sure you are connected to internet',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.sizeOf(context).width,
              color: Colors.amber,
              padding: const EdgeInsets.all(12.0),
              child: const Text('Check only Windows platform compatibility'),
            ),
            checking
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text('Checking packages supported platforms')
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: results.entries.length,
                      itemBuilder: (BuildContext context, int index) {
                        var package = results.entries.elementAt(index);
                        var supportedPlatforms =
                            package.value['platforms'] as List<String>;

                        bool isSupportedToWindows = false;
                        if (supportedPlatforms.isNotEmpty) {
                          // is compatible for windows?
                          if (checker!.isCompatible(supportedPlatforms)) {
                            isSupportedToWindows = true;
                          }
                        }
                        return ListTile(
                          leading: const Icon(Icons.public),
                          title: Text(package.key),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                package.value['version'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 10),
                              isSupportedToWindows
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 16,
                                    )
                                  : const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                            ],
                          ),
                          trailing: Text(
                              '${supportedPlatforms.isNotEmpty ? supportedPlatforms : 'Unknown'}'),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: check,
        tooltip: 'Check',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
