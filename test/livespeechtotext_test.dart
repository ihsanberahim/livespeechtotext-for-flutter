import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:livespeechtotext/livespeechtotext.dart';
import 'package:livespeechtotext/livespeechtotext_platform_interface.dart';
import 'package:livespeechtotext/livespeechtotext_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLivespeechtotextPlatform
    with MockPlatformInterfaceMixin
    implements LivespeechtotextPlatform {
  @override
  StreamSubscription<dynamic> addEventListener(
      String eventName, Function(dynamic p1) callback) {
    return addEventListener('', (p1) => null);
  }

  @override
  Future<String?> getLocaleDisplayName() => Future.value('');

  @override
  Future<Map<String, String>?> getSupportedLocales() => Future.value({});

  @override
  Future<String?> getText() => Future.value('');

  @override
  Future<dynamic> setLocale(String languageTag) => Future.value('');

  @override
  Future<String?> start() => Future.value('');

  @override
  Future<String?> stop() => Future.value('');
}

void main() {
  final LivespeechtotextPlatform initialPlatform =
      LivespeechtotextPlatform.instance;

  test('$MethodChannelLivespeechtotext is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLivespeechtotext>());
  });

  test('getText', () async {
    Livespeechtotext livespeechtotextPlugin = Livespeechtotext();
    MockLivespeechtotextPlatform fakePlatform = MockLivespeechtotextPlatform();
    LivespeechtotextPlatform.instance = fakePlatform;

    expect(await livespeechtotextPlugin.getText(), '');
  });
}
