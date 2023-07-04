# Live Speech-To-Text

Effortlessly add speech-to-text to your Flutter apps, enabling voice-controlled features. Transcribe spoken words into text easier with this plugin.

## SDK
 * Android
  * MinSDK 21 /CompileSDK 31
    * `android/local.properties`
    ```
    def flutterMinSdkVersion = localProperties.getProperty('flutter.minSdkVersion')
    if (flutterMinSdkVersion == null) {
        flutterMinSdkVersion = '21'
    }

    def flutterCompileSdkVersion = localProperties.getProperty('flutter.compileSdkVersion')
    if (flutterCompileSdkVersion == null) {
        flutterCompileSdkVersion = '31'
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

It is highly recommended use [permission_handler:^9.2.0](https://pub.dev/packages/permission_handler) package to make sure the user have required permissions granted.

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
