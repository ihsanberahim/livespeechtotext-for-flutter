package com.overmycloud.livespeechtotext

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.SpeechRecognizer
import androidx.core.content.ContextCompat
import android.content.Intent
import android.os.Build
import android.speech.RecognizerIntent

class LiveSpeechToText(plugin: LivespeechtotextPlugin): RecognitionListener {

    private var speechRecognizer: SpeechRecognizer
    private var pluginInstance: LivespeechtotextPlugin
    private var recognisedText = ""
    private var tempRecognisedText = ""
    private var stopped = false

    init {
        pluginInstance = plugin
        speechRecognizer = SpeechRecognizer.createSpeechRecognizer(pluginInstance.context)
    }

    fun stop() {
//        log("stop")
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

            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_WEB_SEARCH)
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

        speechRecognizer.startListening(recognizerIntent)
    }

    fun getText(): String {
        return recognisedText
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
        recognisedText = ""
        tempRecognisedText = ""
        pluginInstance.onError()
    }

    override fun onResults(results: Bundle) {
        if(!stopped) {
            start()
        }
    }

    private fun requestRecordAudioPermission(): Boolean {
        return ContextCompat.checkSelfPermission(pluginInstance.context,
            Manifest.permission.RECORD_AUDIO
        ) == PackageManager.PERMISSION_GRANTED
    }
}