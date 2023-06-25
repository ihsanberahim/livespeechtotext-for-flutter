import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:livespeechtotext/livespeechtotext.dart';

import 'livespeechtotext_platform_interface.dart';

/// An implementation of [LivespeechtotextPlatform] that uses method channels.
class MethodChannelLivespeechtotext extends LivespeechtotextPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel(Livespeechtotext.channelName);

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
  StreamSubscription addEventListener(
      String eventName, Function(dynamic event) callback) {
    String channelName = Livespeechtotext.channelName;
    EventChannel eventChannel = EventChannel("$channelName/$eventName");

    return eventChannel
        .receiveBroadcastStream()
        .map((event) => event)
        .listen((event) => callback(event));
  }
}
