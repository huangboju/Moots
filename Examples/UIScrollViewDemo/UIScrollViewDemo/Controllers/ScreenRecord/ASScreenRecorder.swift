//
//  ASScreenRecorder.swift
//  ScreenRecorder
//
//  Swift port of ASScreenRecorder (Alan Skipp, 2014)
//  iOS 14+ updates: Photos saving (addOnly), Scene-friendly windows/orientation.
//

import UIKit
import AVFoundation
import Photos

public typealias VideoCompletionBlock = () -> Void

/// If your view contains an AVCaptureVideoPreviewLayer or an OpenGL/Metal view,
/// you may need to draw that content into the context yourself.
public protocol ASScreenRecorderDelegate: AnyObject {
    func writeBackgroundFrame(in context: inout CGContext)
}

public final class ASScreenRecorder: NSObject {
    public static let shared = ASScreenRecorder()

    public private(set) var isRecording: Bool = false
    public weak var delegate: ASScreenRecorderDelegate?

    /// If `videoURL` is nil, the video will be saved into the camera roll.
    /// This property cannot be changed whilst recording is in progress.
    public var videoURL: URL? {
        didSet {
            precondition(!isRecording, "videoURL can not be changed whilst recording is in progress")
        }
    }

    // MARK: - Private writer state
    private var videoWriter: AVAssetWriter?
    private var videoWriterInput: AVAssetWriterInput?
    private var adaptor: AVAssetWriterInputPixelBufferAdaptor?
    private var displayLink: CADisplayLink?

    private var firstTimeStamp: CFTimeInterval = 0

    private let renderQueue = DispatchQueue(label: "ASScreenRecorder.render_queue", qos: .userInitiated)
    private let appendQueue = DispatchQueue(label: "ASScreenRecorder.append_queue")
    private let frameRenderingSemaphore = DispatchSemaphore(value: 1)
    private let pixelAppendSemaphore = DispatchSemaphore(value: 1)

    private var viewSize: CGSize = .zero
    private var scale: CGFloat = 1

    private var rgbColorSpace: CGColorSpace?
    private var outputBufferPool: CVPixelBufferPool?

    private override init() {
        super.init()

        // Scene 下 delegate.window 可能为空，使用屏幕尺寸兜底
        viewSize = UIScreen.main.bounds.size
        scale = UIScreen.main.scale

        // record half size resolution for retina iPads (保持原逻辑)
        if UIDevice.current.userInterfaceIdiom == .pad, scale > 1 {
            scale = 1
        }
    }

    // MARK: - Public
    @discardableResult
    public func startRecording() -> Bool {
        guard !isRecording else { return true }

        setUpWriter()
        isRecording = (videoWriter?.status == .writing)
        guard isRecording else { return false }

        let link = CADisplayLink(target: self, selector: #selector(writeVideoFrame))
        link.add(to: .main, forMode: .common)
        displayLink = link
        return true
    }

    public func stopRecording(completion: VideoCompletionBlock? = nil) {
        guard isRecording else {
            completion?()
            return
        }

        isRecording = false
        displayLink?.invalidate()
        displayLink = nil

        completeRecordingSession(completion: completion)
    }

    // MARK: - Setup
    private func setUpWriter() {
        rgbColorSpace = CGColorSpaceCreateDeviceRGB()

        let width = Int(viewSize.width * scale)
        let height = Int(viewSize.height * scale)

        let bufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA),
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true,
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height,
            kCVPixelBufferBytesPerRowAlignmentKey as String: width * 4,
        ]

        outputBufferPool = nil
        var pool: CVPixelBufferPool?
        CVPixelBufferPoolCreate(nil, nil, bufferAttributes as CFDictionary, &pool)
        outputBufferPool = pool

        let url = videoURL ?? tempFileURL()
        let fileType: AVFileType = .mov

        do {
            videoWriter = try AVAssetWriter(outputURL: url, fileType: fileType)
        } catch {
            assertionFailure("Could not create AVAssetWriter: \(error)")
            videoWriter = nil
            return
        }

        let pixelCount = Int(viewSize.width * viewSize.height * scale)
        let compression: [String: Any] = [
            AVVideoAverageBitRateKey: Int(Double(pixelCount) * 11.4),
        ]

        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
            AVVideoCompressionPropertiesKey: compression,
        ]

        let input = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        input.expectsMediaDataInRealTime = true
        input.transform = videoTransformForCurrentInterfaceOrientation()
        videoWriterInput = input

        adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: nil)

        if let writer = videoWriter, writer.canAdd(input) {
            writer.add(input)
        }

        guard videoWriter?.startWriting() == true else {
            assertionFailure("startWriting failed: \(videoWriter?.error?.localizedDescription ?? "unknown")")
            return
        }
        videoWriter?.startSession(atSourceTime: CMTimeMake(value: 0, timescale: 1000))
        firstTimeStamp = 0
    }

    private func videoTransformForCurrentInterfaceOrientation() -> CGAffineTransform {
        let orientation: UIInterfaceOrientation = {
            for scene in UIApplication.shared.connectedScenes {
                guard scene.activationState == .foregroundActive,
                      let ws = scene as? UIWindowScene
                else { continue }
                return ws.interfaceOrientation
            }
            return .portrait
        }()

        switch orientation {
        case .landscapeLeft:
            return CGAffineTransform(rotationAngle: -.pi / 2)
        case .landscapeRight:
            return CGAffineTransform(rotationAngle: .pi / 2)
        case .portraitUpsideDown:
            return CGAffineTransform(rotationAngle: .pi)
        default:
            return .identity
        }
    }

    private func tempFileURL() -> URL {
        let outputPath = (NSHomeDirectory() as NSString).appendingPathComponent("tmp/screenCapture.mov")
        removeTempFilePath(outputPath)
        return URL(fileURLWithPath: outputPath)
    }

    private func removeTempFilePath(_ filePath: String) {
        let fm = FileManager.default
        guard fm.fileExists(atPath: filePath) else { return }
        do {
            try fm.removeItem(atPath: filePath)
        } catch {
            NSLog("Could not delete old recording: %@", error.localizedDescription)
        }
    }

    // MARK: - Finish
    private func completeRecordingSession(completion: VideoCompletionBlock?) {
        renderQueue.async { [weak self] in
            guard let self else { return }
            self.appendQueue.sync {
                self.videoWriterInput?.markAsFinished()

                self.videoWriter?.finishWriting { [weak self] in
                    guard let self else { return }

                    let done: () -> Void = {
                        self.cleanup()
                        DispatchQueue.main.async { completion?() }
                    }

                    if self.videoURL != nil {
                        done()
                    } else {
                        self.saveToPhotoLibrary(url: self.videoWriter?.outputURL, completion: done)
                    }
                }
            }
        }
    }

    private func saveToPhotoLibrary(url: URL?, completion: @escaping () -> Void) {
        guard let url else {
            completion()
            return
        }

        let saveBlock: (PHAuthorizationStatus) -> Void = { [weak self] status in
            guard let self else { return }
            guard status == .authorized || status == .limited else {
                NSLog("Error copying video to camera roll: Photo permission not granted (%ld)", status.rawValue)
                completion()
                return
            }

            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .video, fileURL: url, options: nil)
            }, completionHandler: { success, error in
                if let error {
                    NSLog("Error copying video to camera roll: %@", error.localizedDescription)
                } else if success {
                    self.removeTempFilePath(url.path)
                }
                completion()
            })
        }

        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            saveBlock(status)
        }
    }

    private func cleanup() {
        adaptor = nil
        videoWriterInput = nil
        videoWriter = nil
        firstTimeStamp = 0
        rgbColorSpace = nil
        outputBufferPool = nil
    }

    // MARK: - Frame rendering
    private func allApplicationWindows() -> [UIWindow] {
        var windows: [UIWindow] = []
        for scene in UIApplication.shared.connectedScenes {
            guard let ws = scene as? UIWindowScene else { continue }
            windows.append(contentsOf: ws.windows)
        }
        return windows
    }

    @objc private func writeVideoFrame() {
        // throttle the number of frames to prevent meltdown
        guard frameRenderingSemaphore.wait(timeout: .now()) == .success else { return }

        renderQueue.async { [weak self] in
            guard let self else { return }
            defer { self.frameRenderingSemaphore.signal() }

            guard let input = self.videoWriterInput, input.isReadyForMoreMediaData else { return }
            guard let displayLink = self.displayLink else { return }

            if self.firstTimeStamp == 0 {
                self.firstTimeStamp = displayLink.timestamp
            }
            let elapsed = displayLink.timestamp - self.firstTimeStamp
            let time = CMTimeMakeWithSeconds(elapsed, preferredTimescale: 1000)

            var pixelBuffer: CVPixelBuffer?
            guard let bitmapContext = self.createPixelBufferAndBitmapContext(pixelBuffer: &pixelBuffer),
                  let pb = pixelBuffer
            else { return }

            // optional delegate background render (e.g. camera preview / OpenGL / Metal)
            var ctx = bitmapContext
            if let delegate = self.delegate {
                delegate.writeBackgroundFrame(in: &ctx)
            }

            // draw each window into the context
            DispatchQueue.main.sync {
                UIGraphicsPushContext(bitmapContext)
                for window in self.allApplicationWindows() {
                    window.drawHierarchy(in: CGRect(x: 0, y: 0, width: self.viewSize.width, height: self.viewSize.height),
                                         afterScreenUpdates: false)
                }
                UIGraphicsPopContext()
            }

            // append pixelBuffer on an async queue (don't overwhelm)
            if self.pixelAppendSemaphore.wait(timeout: .now()) == .success {
                self.appendQueue.async { [weak self] in
                    guard let self else { return }
                    defer { self.pixelAppendSemaphore.signal() }

                    let success = self.adaptor?.append(pb, withPresentationTime: time) ?? false
                    if !success {
                        NSLog("Warning: Unable to write buffer to video")
                    }
                }
            }
        }
    }

    private func createPixelBufferAndBitmapContext(pixelBuffer: inout CVPixelBuffer?) -> CGContext? {
        guard let pool = outputBufferPool else { return nil }

        var pb: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(nil, pool, &pb)
        guard let pbUnwrapped = pb else { return nil }
        pixelBuffer = pbUnwrapped

        CVPixelBufferLockBaseAddress(pbUnwrapped, [])
        defer { CVPixelBufferUnlockBaseAddress(pbUnwrapped, []) }

        guard let cs = rgbColorSpace else { return nil }
        guard let ctx = CGContext(
            data: CVPixelBufferGetBaseAddress(pbUnwrapped),
            width: CVPixelBufferGetWidth(pbUnwrapped),
            height: CVPixelBufferGetHeight(pbUnwrapped),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pbUnwrapped),
            space: cs,
            bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        ) else { return nil }

        // match original transform pipeline
        ctx.scaleBy(x: scale, y: scale)
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: viewSize.height)
        ctx.concatenate(flipVertical)

        return ctx
    }
}


