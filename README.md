# livespeechtotext

A powerful tool that enables continuous speech-to-text functionality within your Flutter applications. This plugin leverages the device's microphone to capture speech and converts it into text in real-time.

With this plugin, you can easily integrate speech recognition capabilities into your Flutter app, opening up a world of possibilities for voice-controlled features. Whether you're building a voice assistant, a transcription app, or any application that requires converting spoken words into written text, this plugin has got you covered.

By utilizing continuous speech recognition, the plugin enables a seamless and uninterrupted experience for users. They can simply speak into the microphone, and the plugin will transcribe their words into text instantly and continuously.

This Flutter plugin offers a straightforward API, making it easy to implement and customize according to your application's needs. With its efficiency and accuracy, you can enhance user interactions and create innovative voice-driven experiences in your Flutter projects.

## SDK
 * Android
  * MinSDK/CompileSDK 33
    * `android/local.properties`
    ```
    def flutterMinSdkVersion = localProperties.getProperty('flutter.minSdkVersion')
    if (flutterMinSdkVersion == null) {
        flutterMinSdkVersion = '33'
    }

    def flutterCompileSdkVersion = localProperties.getProperty('flutter.compileSdkVersion')
    if (flutterCompileSdkVersion == null) {
        flutterCompileSdkVersion = '33'
    }
    ```
    * `android/app/build.gradle`
    ```
    android {
        ...
        compileSdkVersion flutterCompileSdkVersion.toInteger()
        ...

        defaultConfig {
          ...
          minSdkVersion flutterMinSdkVersion.toInteger()
          ...
        }
    }
    ```
  * iOS
    * this package tested on target iOS 13

## Permissions

It is highly recommended use '[permission_handler](https://pub.dev/packages/permission_handler)' package to make sure the user have required permissions granted.

* Android
  * `android/app/src/{debug,main,profile}/AndroidManifest.xml`
  ```
  <uses-permission android:name="android.permission.RECORD_AUDIO" />
  <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
  ```
* iOS
  * `ios/Runner/Info.plist`
  ```
  <key>NSMicrophoneUsageDescription</key>
	<string>Your voice input needed for the speech to text functionality</string>
	<key>NSSpeechRecognitionUsageDescription</key>
	<string>Allow app to get text input from your speech</string>
  ```
  * `ios/Podfile`
    * First refer the [guide](https://pub.dev/packages/permission_handler#setup)
    * Uncomment these lines
    ```
          ## dart: PermissionGroup.microphone
          'PERMISSION_MICROPHONE=1',

          ## dart: PermissionGroup.speech
          'PERMISSION_SPEECH_RECOGNIZER=1',
    ```

## Troubleshoots

* Android Emulator (without Android Studio) not receive input from microphone on MacOS 13
  * Open 'Activity Monitor' find process name like 'qemu'. get the full process name
  * run command
    *  `sudo defaults write com.apple.security.device.microphone qemu-system-aarch64 -bool true`
    * restart the emulator
