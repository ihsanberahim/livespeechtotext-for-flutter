package com.overmycloud.livespeechtotext

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler

/** LivespeechtotextPlugin */
class LivespeechtotextPlugin: FlutterPlugin, MethodCallHandler, StreamHandler {
  lateinit var context: Context

  private lateinit var channel : MethodChannel
  private lateinit var eventChannel : EventChannel
  private lateinit var lst: LiveSpeechToText
  private var eventSink: EventChannel.EventSink? = null
  var channelName = "livespeechtotext"

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
    channel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "${channelName}/success")
    eventChannel.setStreamHandler(this)

    lst = LiveSpeechToText(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "start" -> {
        lst.start()

        result.success("")
      }
      "stop" -> {
        lst.stop()

        result.success("")
      }
      "getText" -> {
        result.success(lst.getText())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventChannel.setStreamHandler(null)
  }

  fun onEndOfSpeech(receivedText: String) {
    eventSink?.success(receivedText)
  }

  fun onPartialResults(receivedText: String) {
    eventSink?.success(receivedText)
  }

  fun onError() {
    eventSink?.success(null)
  }
}
