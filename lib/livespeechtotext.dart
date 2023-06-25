import 'dart:async';

import 'livespeechtotext_platform_interface.dart';

class Livespeechtotext {
  static const String channelName = "livespeechtotext";
  static const String eventSuccess = "success";

  LivespeechtotextPlatform get _methodChannel =>
      LivespeechtotextPlatform.instance;
  LivespeechtotextPlatform get _eventChannel =>
      LivespeechtotextPlatform.instance;

  Future<String?> start() {
    return _methodChannel.start();
  }

  Future<String?> getText() {
    return _methodChannel.getText();
  }

  Future<String?> stop() {
    return _methodChannel.stop();
  }

  StreamSubscription<dynamic> addEventListener(
    String eventName,
    Function(dynamic) callback,
  ) {
    return _eventChannel.addEventListener(eventName, callback);
  }
}
