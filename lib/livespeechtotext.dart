import 'dart:async';

import 'livespeechtotext_platform_interface.dart';

class Livespeechtotext {
  /// Channel name prefix
  static const String channelName = "livespeechtotext";

  /// Event name suffix
  static const String eventSuccess = "success";

  LivespeechtotextPlatform get _methodChannel =>
      LivespeechtotextPlatform.instance;
  LivespeechtotextPlatform get _eventChannel =>
      LivespeechtotextPlatform.eventInstance;

  /// Method to listen an event
  ///
  /// Supported value of `eventName` are:
  /// * "success"
  StreamSubscription<dynamic> addEventListener(
    String eventName,
    Function(dynamic) callback,
  ) {
    return _eventChannel.addEventListener(eventName, callback);
  }

  /// Method to get the current active language display name
  Future<String?> getLocaleDisplayName() {
    return _methodChannel.getLocaleDisplayName();
  }

  /// Method to get supported languages
  Future<Map<String, String>?> getSupportedLocales() {
    return _methodChannel.getSupportedLocales();
  }

  /// Method to get the speech recognized text
  Future<String?> getText() {
    return _methodChannel.getText();
  }

  /// Method to set speech recognizer language
  ///
  /// Example of `languageTag` values are
  /// * "en-US"
  /// * "ms-MY"
  Future<dynamic> setLocale(String languageTag) {
    return _methodChannel.setLocale(languageTag);
  }

  /// Method to start the speech-to-text
  Future<String?> start() {
    return _methodChannel.start();
  }

  /// Method to stop the speech-to-text
  Future<String?> stop() {
    return _methodChannel.stop();
  }
}
