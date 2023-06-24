import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'livespeechtotext_platform_interface.dart';

/// An implementation of [LivespeechtotextPlatform] that uses method channels.
class EventChannelLivespeechtotext extends LivespeechtotextPlatform {
  EventChannelLivespeechtotext() {
    onSuccessEvent = EventChannel("$channelName/success");
    onAnyEvent = EventChannel(channelName);
  }

  final String channelName = "livespeechtotext";

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  late final EventChannel onSuccessEvent;

  @visibleForTesting
  late final EventChannel onAnyEvent;

  @override
  StreamSubscription<dynamic> addEventListener(
      String eventName, Function(dynamic) callback) {
    switch (eventName) {
      case 'success':
        return onSuccessEvent
            .receiveBroadcastStream()
            .map<dynamic>((event) => event)
            .listen((event) => callback(event));
      default:
        return onAnyEvent
            .receiveBroadcastStream()
            .map<dynamic>((event) => event)
            .listen((event) => callback(event['text']));
    }
  }
}
