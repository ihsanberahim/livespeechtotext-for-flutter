# livespeechtotext

A powerful tool that enables continuous speech-to-text functionality within your Flutter applications. This plugin leverages the device's microphone to capture speech and converts it into text in real-time.

With this plugin, you can easily integrate speech recognition capabilities into your Flutter app, opening up a world of possibilities for voice-controlled features. Whether you're building a voice assistant, a transcription app, or any application that requires converting spoken words into written text, this plugin has got you covered.

By utilizing continuous speech recognition, the plugin enables a seamless and uninterrupted experience for users. They can simply speak into the microphone, and the plugin will transcribe their words into text instantly and continuously.

This Flutter plugin offers a straightforward API, making it easy to implement and customize according to your application's needs. With its efficiency and accuracy, you can enhance user interactions and create innovative voice-driven experiences in your Flutter projects.


## Troubleshoots

* Android Emulator (without Android Studio) not receive input from microphone on MacOS 13
  * Open 'Activity Monitor' find process name like 'qemu'. get the full process name
  * run command
    *  `sudo defaults write com.apple.security.device.microphone qemu-system-aarch64 -bool true`
    * restart the emulator
