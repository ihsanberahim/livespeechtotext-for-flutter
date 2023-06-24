import 'dart:async';

import 'livespeechtotext_platform_interface.dart';

class Livespeechtotext {
  Future<String?> start() {
    return LivespeechtotextPlatform.instance.start();
  }

  Future<String?> getText() {
    return LivespeechtotextPlatform.instance.getText();
  }

  Future<String?> stop() {
    return LivespeechtotextPlatform.instance.stop();
  }

  StreamSubscription<dynamic> addEventListener(
      String eventName, Function(dynamic) callback) {
    return LivespeechtotextPlatform.eventChannel
        .addEventListener(eventName, callback);
  }
}
