import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'livespeechtotext_platform_interface.dart';

/// An implementation of [LivespeechtotextPlatform] that uses method channels.
class MethodChannelLivespeechtotext extends LivespeechtotextPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('livespeechtotext');
  final eventChannel = const EventChannel('livespeechtotext');

  @override
  Future<String?> start() async {
    final output = await methodChannel.invokeMethod<String>('start');
    return output;
  }

  @override
  Future<String?> stop() async {
    final output = await methodChannel.invokeMethod<String>('stop');
    return output;
  }

  @override
  Future<String?> getText() async {
    final output = await methodChannel.invokeMethod<String>('getText');
    return output;
  }

  @override
  StreamSubscription<Map<String, dynamic>> addEventListener(
      String eventName, Function(String? text) callback) {
    EventChannel eventChannel = EventChannel("livespeechtotext/$eventName");

    return eventChannel
        .receiveBroadcastStream()
        .map<Map<String, dynamic>>((event) => event)
        .listen((event) => callback(event['text']));
  }
}
