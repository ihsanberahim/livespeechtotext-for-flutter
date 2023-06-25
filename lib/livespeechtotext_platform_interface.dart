import 'dart:async';

import 'package:livespeechtotext/livespeechtotext_event_channel.dart';
import 'package:livespeechtotext/livespeechtotext_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class LivespeechtotextPlatform extends PlatformInterface {
  /// Constructs a LivespeechtotextPlatform.
  LivespeechtotextPlatform() : super(token: _token);

  static final Object _token = Object();
  static LivespeechtotextPlatform _methodChannel =
      MethodChannelLivespeechtotext();
  static LivespeechtotextPlatform _eventChannel =
      EventChannelLivespeechtotext();

  /// The default instance of [LivespeechtotextPlatform] to use.
  ///
  /// Defaults to [MethodChannelLivespeechtotext].
  static LivespeechtotextPlatform get instance => _methodChannel;

  static LivespeechtotextPlatform get eventInstance => _eventChannel;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LivespeechtotextPlatform] when
  /// they register themselves.
  static set instance(LivespeechtotextPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _methodChannel = instance;
    _eventChannel = instance;
  }

  Future<String?> start() {
    throw UnimplementedError('start() has not been implemented.');
  }

  Future<String?> stop() {
    throw UnimplementedError('stop() has not been implemented.');
  }

  Future<String?> getText() {
    throw UnimplementedError('getText() has not been implemented.');
  }

  StreamSubscription<dynamic> addEventListener(
    String eventName,
    Function(dynamic) callback,
  ) {
    throw UnimplementedError('addEventListener() has not been implemented.');
  }
}
