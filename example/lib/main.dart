import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:livespeechtotext/livespeechtotext.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Livespeechtotext _livespeechtotextPlugin;
  late String _recognisedText;
  String? _localeDisplayName = '';
  late StreamSubscription<dynamic>? onSuccess;

  @override
  void initState() {
    super.initState();
    _livespeechtotextPlugin = Livespeechtotext();

    // _livespeechtotextPlugin.setLocale('en-MY').then((value) async {
    //   _localeDisplayName = await _livespeechtotextPlugin.getLocaleDisplayName();

    //   setState(() {});
    // });

    _livespeechtotextPlugin.getLocaleDisplayName().then((value) => setState(
          () => _localeDisplayName = value,
        ));

    onSuccess = _livespeechtotextPlugin.addEventListener('success', (text) {
      setState(() {
        _recognisedText = text ?? '';
      });
    });

    // _livespeechtotextPlugin
    //     .getSupportedLocales()
    //     .then((value) => value?.entries.forEach((element) {
    //           print(element);
    //         }));

    _recognisedText = '';
  }

  @override
  void dispose() {
    onSuccess?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Live Speech To Text'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(_recognisedText),
              ElevatedButton(
                  onPressed: () {
                    print("start button pressed");
                    try {
                      _livespeechtotextPlugin.start();
                    } on PlatformException {
                      print('error');
                    }
                  },
                  child: const Text('Start')),
              ElevatedButton(
                  onPressed: () {
                    print("stop button pressed");
                    try {
                      _livespeechtotextPlugin.stop();
                    } on PlatformException {
                      print('error');
                    }
                  },
                  child: const Text('Stop')),
              Text("Locale: $_localeDisplayName"),
            ],
          ),
        ),
      ),
    );
  }
}
