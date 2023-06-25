import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'livespeechtotext.dart';
import 'livespeechtotext_platform_interface.dart';

/// An implementation of [LivespeechtotextPlatform] that uses method channels.
class EventChannelLivespeechtotext extends LivespeechtotextPlatform {
  EventChannelLivespeechtotext() {
    const String channelName = Livespeechtotext.channelName;
    const String eventSuccess = Livespeechtotext.eventSuccess;

    onSuccessEvent = const EventChannel("$channelName/$eventSuccess");
    onAnyEvent = const EventChannel(channelName);
  }

  @visibleForTesting
  late final EventChannel onSuccessEvent;

  @visibleForTesting
  late final EventChannel onAnyEvent;

  @override
  StreamSubscription<dynamic> addEventListener(
    String eventName,
    Function(dynamic) callback,
  ) {
    switch (eventName) {
      case Livespeechtotext.eventSuccess:
        return onSuccessEvent
            .receiveBroadcastStream()
            .map<dynamic>((event) => event)
            .listen((event) => callback(event));
      default:
        return onAnyEvent
            .receiveBroadcastStream()
            .map<dynamic>((event) => event)
            .listen((event) => callback(event));
    }
  }
}
