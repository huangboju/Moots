import Foundation
import ReplayKit
import AVFoundation
import Photos
import Combine

@MainActor
final class ReplayCaptureRecorder: ObservableObject {
    @Published private(set) var isRecording: Bool = false
    @Published private(set) var statusText: String = "就绪"

    private let recorder = RPScreenRecorder.shared()
    private let writeQueue = DispatchQueue(label: "replay.capture.writer.queue")

    private var writer: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var adaptor: AVAssetWriterInputPixelBufferAdaptor?
    private var appAudioInput: AVAssetWriterInput?

    private var outputURL: URL?
    private var sessionStarted = false

    private let audioPlayer = AudioPlayer()

    func start(playMusic: Bool) {
        guard recorder.isAvailable else {
            statusText = "录屏不可用（请真机运行）"
            return
        }
        guard !isRecording else { return }

        statusText = "准备开始…"
        isRecording = true
        sessionStarted = false

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("replaykit_demo_\(UUID().uuidString).mov")
        outputURL = url

        writeQueue.async {
            try? FileManager.default.removeItem(at: url)
        }

        if playMusic {
            do {
                try audioPlayer.prepareSession()
                try audioPlayer.playBundledMP3(named: "background_music") // 对应 demo.mp3
            } catch {
                statusText = "音乐播放失败：\(error.localizedDescription)"
            }
        }

        recorder.startCapture(handler: { [weak self] sampleBuffer, sampleType, error in
            guard let self else { return }
            if let error = error {
                Task { @MainActor in
                    self.statusText = "录制中断：\(error.localizedDescription)"
                    self.isRecording = false
                }
                return
            }
            self.handle(sampleBuffer: sampleBuffer, type: sampleType)
        }, completionHandler: { [weak self] error in
            Task { @MainActor in
                if let error = error {
                    self?.statusText = "开始录制失败：\(error.localizedDescription)"
                    self?.isRecording = false
                } else {
                    self?.statusText = "录制中…"
                }
            }
        })
    }

    func stop() {
        guard isRecording else { return }
        statusText = "停止中…"

        audioPlayer.stop()

        recorder.stopCapture { [weak self] error in
            guard let self else { return }
            if let error = error {
                Task { @MainActor in
                    self.statusText = "停止失败：\(error.localizedDescription)"
                    self.isRecording = false
                }
                return
            }
            self.finishWritingAndSave()
        }
    }

    private func handle(sampleBuffer: CMSampleBuffer, type: RPSampleBufferType) {
        writeQueue.async { [weak self] in
            guard let self else { return }
            guard self.isRecording else { return }

            switch type {
            case .video:
                self.handleVideo(sampleBuffer)
            case .audioApp:
                self.handleAppAudio(sampleBuffer)
            case .audioMic:
                break // demo 默认不写入麦克风
            @unknown default:
                break
            }
        }
    }

    private func ensureWriterIfNeeded(withFirstVideoSample sampleBuffer: CMSampleBuffer) throws {
        guard writer == nil else { return }
        guard let url = outputURL else { throw NSError(domain: "ReplayCaptureRecorder", code: -2) }

        let w = try AVAssetWriter(outputURL: url, fileType: .mov)

        guard let formatDesc = CMSampleBufferGetFormatDescription(sampleBuffer) else {
            throw NSError(domain: "ReplayCaptureRecorder", code: -3, userInfo: [NSLocalizedDescriptionKey: "无法获取视频格式信息"])
        }
        let dims = CMVideoFormatDescriptionGetDimensions(formatDesc)
        let width = Int(dims.width)
        let height = Int(dims.height)

        let vSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height
        ]
        let vIn = AVAssetWriterInput(mediaType: .video, outputSettings: vSettings)
        vIn.expectsMediaDataInRealTime = true

        let attrs: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA),
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height
        ]
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: vIn, sourcePixelBufferAttributes: attrs)

        let aSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100,
            AVEncoderBitRateKey: 128000
        ]
        let aIn = AVAssetWriterInput(mediaType: .audio, outputSettings: aSettings)
        aIn.expectsMediaDataInRealTime = true

        if w.canAdd(vIn) { w.add(vIn) }
        if w.canAdd(aIn) { w.add(aIn) }

        self.writer = w
        self.videoInput = vIn
        self.adaptor = adaptor
        self.appAudioInput = aIn
    }

    private func startSessionIfNeeded(at pts: CMTime) throws {
        guard let w = writer else { return }
        guard !sessionStarted else { return }

        if w.startWriting() {
            w.startSession(atSourceTime: pts)
            sessionStarted = true
        } else {
            throw w.error ?? NSError(domain: "ReplayCaptureRecorder", code: -4, userInfo: [NSLocalizedDescriptionKey: "startWriting 失败"])
        }
    }

    private func handleVideo(_ sampleBuffer: CMSampleBuffer) {
        do {
            try ensureWriterIfNeeded(withFirstVideoSample: sampleBuffer)
            let pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            try startSessionIfNeeded(at: pts)

            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
                  let vIn = videoInput,
                  let adaptor = adaptor,
                  vIn.isReadyForMoreMediaData else { return }

            adaptor.append(pixelBuffer, withPresentationTime: pts)
        } catch {
            Task { @MainActor in
                self.statusText = "写入视频失败：\(error.localizedDescription)"
                self.isRecording = false
            }
        }
    }

    private func handleAppAudio(_ sampleBuffer: CMSampleBuffer) {
        guard let aIn = appAudioInput else { return }   // 音频先到会丢弃，等视频来了再开始写
        guard sessionStarted else { return }
        guard aIn.isReadyForMoreMediaData else { return }
        aIn.append(sampleBuffer)
    }

    private func finishWritingAndSave() {
        writeQueue.async { [weak self] in
            guard let self else { return }
            guard let w = self.writer, let url = self.outputURL else {
                Task { @MainActor in
                    self.statusText = "没有可保存的录屏文件"
                    self.isRecording = false
                }
                return
            }

            self.videoInput?.markAsFinished()
            self.appAudioInput?.markAsFinished()

            w.finishWriting {
                let err = w.error
                Task { @MainActor in
                    if let err = err {
                        self.statusText = "写文件失败：\(err.localizedDescription)"
                        self.isRecording = false
                        return
                    }
                    self.saveToPhotos(videoURL: url)
                }
            }
        }
    }

    private func saveToPhotos(videoURL: URL) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
            guard let self else { return }
            guard status == .authorized || status == .limited else {
                Task { @MainActor in
                    self.statusText = "没有相册写入权限（去系统设置允许）"
                    self.isRecording = false
                }
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            }, completionHandler: { success, error in
                Task { @MainActor in
                    self.statusText = success ? "已保存到相册" : "保存失败：\(error?.localizedDescription ?? "未知错误")"
                    self.isRecording = false
                }
                try? FileManager.default.removeItem(at: videoURL)
            })
        }
    }
}

final class AudioPlayer {
    private var player: AVAudioPlayer?

    func prepareSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .default, options: [])
        try session.setActive(true)
    }

    func playBundledMP3(named name: String) throws {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            throw NSError(domain: "AudioPlayer", code: -1, userInfo: [NSLocalizedDescriptionKey: "找不到资源：\(name).mp3"])
        }
        player = try AVAudioPlayer(contentsOf: url)
        player?.numberOfLoops = -1
        player?.prepareToPlay()
        player?.play()
    }

    func stop() {
        player?.stop()
        player = nil
    }
}
