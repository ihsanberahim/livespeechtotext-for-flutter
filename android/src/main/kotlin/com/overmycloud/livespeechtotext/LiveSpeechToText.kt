package com.overmycloud.livespeechtotext

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.media.AudioManager
import android.os.Build
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import androidx.core.content.ContextCompat
import androidx.core.content.ContextCompat.getSystemService
import java.util.Locale

class LiveSpeechToText(plugin: LivespeechtotextPlugin): RecognitionListener {

    private var speechRecognizer: SpeechRecognizer
    private var pluginInstance: LivespeechtotextPlugin
    private var recognisedText = ""
    private var tempRecognisedText = ""
    private var stopped = false
    private var currentLocale: Locale = Locale.getDefault()

    init {
        pluginInstance = plugin
        speechRecognizer = SpeechRecognizer.createSpeechRecognizer(pluginInstance.context)

        currentLocale = Locale.getDefault()
    }

    fun stop() {
        speechRecognizer.stopListening()
        speechRecognizer.destroy()
        stopped = true
    }

    fun start() {
        stopped = false

        var granted = requestRecordAudioPermission()

        if(!granted) {
            return
        }

        val recognizerIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {

            putExtra(RecognizerIntent.EXTRA_LANGUAGE, currentLocale)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_CALLING_PACKAGE, pluginInstance.context.packageName)
            putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                putExtra(RecognizerIntent.EXTRA_PREFER_OFFLINE, true)
            }
        }

        if (SpeechRecognizer.isRecognitionAvailable(pluginInstance.context)) {
            speechRecognizer.setRecognitionListener(this)
        } else {
            pluginInstance.onError()
            return
        }

        muteAudio()
        speechRecognizer.startListening(recognizerIntent)
    }

    fun getText(): String {
        return recognisedText
    }

    private fun getCurrentLocale(): Locale {
        return currentLocale
    }

    fun getLocaleTag(): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            currentLocale.toLanguageTag()
        } else {
            ""
        }
    }

    fun getLocaleDisplayName(): String {
        return currentLocale.displayName
    }


    fun setLocale(languageTag: String) {
        if (!stopped) {
            stop()
        }

        currentLocale = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Locale.forLanguageTag(languageTag)
        } else {
            Locale.getDefault()
        }
    }

    fun getSupportedLocales(): MutableMap<String, String> {
        val locales = mutableMapOf<String, String>()

        locales[""] = Locale.getDefault().displayName

        return locales
    }

    override fun onPartialResults(partialResults: Bundle) {
        val matches = partialResults.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
        if (matches != null) {
            tempRecognisedText = matches[0]
            pluginInstance.onPartialResults(tempRecognisedText)
        }
    }

    override fun onEvent(eventType: Int, params: Bundle?) {
//    TODO("Not yet implemented")
    }

    override fun onReadyForSpeech(params: Bundle?) {
//    TODO("Not yet implemented")
    }

    override fun onBeginningOfSpeech() {
//    TODO("Not yet implemented")
    }

    override fun onRmsChanged(rmsdB: Float) {
//    TODO("Not yet implemented")
    }

    override fun onBufferReceived(buffer: ByteArray?) {
//    TODO("Not yet implemented")
    }

    override fun onEndOfSpeech() {
        recognisedText = tempRecognisedText
        pluginInstance.onEndOfSpeech(recognisedText)
    }

    override fun onError(error: Int) {
        if(!stopped) {
            start()
            return
        }

        recognisedText = ""
        tempRecognisedText = ""
        pluginInstance.onError()

        unmuteAudio()
    }

    override fun onResults(results: Bundle) {
        if(!stopped) {
            start()
            return
        }

        unmuteAudio()
    }

    private fun requestRecordAudioPermission(): Boolean {
        return ContextCompat.checkSelfPermission(pluginInstance.context,
            Manifest.permission.RECORD_AUDIO
        ) == PackageManager.PERMISSION_GRANTED
    }

    fun muteAudio() {
        // Get the AudioManager instance.
        val audioManager = getSystemService(pluginInstance.context, AudioManager::class.java) as AudioManager

        // Mute all streams.
        audioManager.adjustStreamVolume(AudioManager.STREAM_SYSTEM, AudioManager.ADJUST_MUTE, 0)
    }

    fun unmuteAudio() {
        // Get the AudioManager instance.
        val audioManager = getSystemService(pluginInstance.context, AudioManager::class.java) as AudioManager

        // Mute all streams.
        audioManager.adjustStreamVolume(AudioManager.STREAM_SYSTEM, AudioManager.ADJUST_UNMUTE, 0)
    }
}