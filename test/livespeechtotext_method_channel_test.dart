import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livespeechtotext/livespeechtotext_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelLivespeechtotext platform = MethodChannelLivespeechtotext();
  const MethodChannel channel = MethodChannel('livespeechtotext');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getText', () async {
    expect(await platform.getText(), '');
  });
}
