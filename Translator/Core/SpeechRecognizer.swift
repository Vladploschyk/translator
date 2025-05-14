import Foundation
import Speech
import AVFoundation

final class SpeechRecognizer {

    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

    private var isRecording = false
    private var finalTranscription: String = ""
    private var storedHandler: ((String?) -> Void)?

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                completion(authStatus == .authorized)
            }
        }
    }

    func startRecording(resultHandler: @escaping (String?) -> Void) throws {
        print("✅ startRecording called")

        stopRecording()
        finalTranscription = ""
        storedHandler = resultHandler

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .default, options: .duckOthers)
        try session.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            print("❌ Failed to create recognitionRequest")
            resultHandler(nil)
            return
        }
        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)

        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        isRecording = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                let text = result.bestTranscription.formattedString
                print("🧠 partial: \(text)")
                self.finalTranscription = text
            } else if let error = error {
                print("❌ Recognition error: \(error.localizedDescription)")
            }
        }
    }

    func stopRecording() {
        if isRecording {
            print("🛑 stopRecording called")
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest?.endAudio()
            recognitionTask?.finish()
            isRecording = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.storedHandler?(self.finalTranscription.isEmpty ? nil : self.finalTranscription)
                self.storedHandler = nil
            }
        }
    }
}
