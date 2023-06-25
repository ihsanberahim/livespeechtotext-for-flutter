import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:livespeechtotext/livespeechtotext.dart';

import 'livespeechtotext_platform_interface.dart';

/// An implementation of [LivespeechtotextPlatform] that uses method channels.
class MethodChannelLivespeechtotext extends LivespeechtotextPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel(Livespeechtotext.channelName);

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

  @override
  Future<String?> getLocaleDisplayName() async {
    final output = await methodChannel.invokeMethod('getLocaleDisplayName');
    return output;
  }

  @override
  Future<Map<String, String>?> getSupportedLocales() async {
    final output = await methodChannel.invokeMethod('getSupportedLocales');

    var sample = output as Map<dynamic, dynamic>;
    Map<String, String> mapping = {};

    for (var item in sample.entries) {
      mapping.addAll({'${item.key}': '${item.value}'});
    }

    return mapping;
  }

  @override
  Future<String?> getText() async {
    final output = await methodChannel.invokeMethod('getText');
    return output;
  }

  @override
  Future<dynamic> setLocale(String languageTag) async {
    final output = await methodChannel
        .invokeMethod('setLocale', <String, dynamic>{'tag': languageTag});
    return output;
  }

  @override
  Future<String?> start() async {
    final output = await methodChannel.invokeMethod('start');
    return output;
  }

  @override
  Future<String?> stop() async {
    final output = await methodChannel.invokeMethod('stop');
    return output;
  }
}
