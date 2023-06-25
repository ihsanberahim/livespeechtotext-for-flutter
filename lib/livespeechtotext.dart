import 'dart:async';

import 'livespeechtotext_platform_interface.dart';

class Livespeechtotext {
  static const String channelName = "livespeechtotext";
  static const String eventSuccess = "success";

  LivespeechtotextPlatform get _methodChannel =>
      LivespeechtotextPlatform.instance;
  LivespeechtotextPlatform get _eventChannel =>
      LivespeechtotextPlatform.instance;

  StreamSubscription<dynamic> addEventListener(
    String eventName,
    Function(dynamic) callback,
  ) {
    return _eventChannel.addEventListener(eventName, callback);
  }

  Future<String?> getLocaleDisplayName() {
    return _methodChannel.getLocaleDisplayName();
  }

  Future<Map<String, String>?> getSupportedLocales() {
    return _methodChannel.getSupportedLocales();
  }

  Future<String?> getText() {
    return _methodChannel.getText();
  }

  Future<dynamic> setLocale(String languageTag) {
    return _methodChannel.setLocale(languageTag);
  }

  Future<String?> start() {
    return _methodChannel.start();
  }

  Future<String?> stop() {
    return _methodChannel.stop();
  }
}
