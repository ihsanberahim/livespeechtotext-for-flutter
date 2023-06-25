import Flutter
import UIKit
import Speech

public class LivespeechtotextPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
    private var recognitionTask: SFSpeechRecognitionTask?
    private var authorized: Bool = false
    private var recognizedText: String = ""
    public static let channelName: String = "livespeechtotext"
    private var eventSink: FlutterEventSink? = nil
    
  public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: self.channelName, binaryMessenger: registrar.messenger())
      
      let instance = LivespeechtotextPlugin()
    
      let eventChannel = FlutterEventChannel(name: "\(self.channelName)/success", binaryMessenger: registrar.messenger())
    
      eventChannel.setStreamHandler(instance)
      registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "start":
        self.getPermissions{
            do {
                guard self.authorized else {
                    result("")
                    return
                }
                
                try self.start(flutterResult: result)
            } catch {
                result("")
            }
        }
        break
    case "stop":
        self.stop()
        result("")
        break
    case "getText":
        result(recognizedText)
        break
    default:
        result(FlutterMethodNotImplemented)
    }
  }
    
    public func start(flutterResult: @escaping FlutterResult) throws {
        recognitionTask?.cancel()
        self.recognitionTask = nil

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0)
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true

        if #available(iOS 13, *) {
            if speechRecognizer?.supportsOnDeviceRecognition ?? false{
                recognitionRequest.requiresOnDeviceRecognition = true
            }
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    let transcribedString = result.bestTranscription.formattedString
                    
//                    self.recognizedText = transcribedString
                    
//                    print("transcribedString: \(transcribedString)")
                    self.eventSink?(transcribedString)
                    
                    flutterResult((transcribedString))
                }
            }
            if error != nil {
                self.stop()
                self.eventSink?(nil)
                flutterResult(nil)
                print(error)
            }
        }
    }
    
    public func stop() {
        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.recognitionRequest = nil
        self.recognitionTask?.cancel()
        self.recognitionTask = nil
    }
    
    public func getPermissions(callback: @escaping () -> Void){
        SFSpeechRecognizer.requestAuthorization{authStatus in
            OperationQueue.main.addOperation {
               switch authStatus {
                    case .authorized:
                        print("authorised..")
                        self.authorized = true
                        callback()
                        break
                    default:
                        print("none")
                        break
               }
            }
        }
    }
}
