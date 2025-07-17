//
//  SiriWaveViewController.swift
//  WaterWave
//
//  Created by bula on 2025/7/16.
//  Copyright © 2025 xiAo_Ju. All rights reserved.
//

import AVFoundation
import UIKit

final class SiriWaveViewController: UIViewController {

    private var recorder:AVAudioRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(siriWave)
        siriWave.backgroundColor = .white
        siriWave.translatesAutoresizingMaskIntoConstraints = false
        siriWave.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        siriWave.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        siriWave.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        siriWave.heightAnchor.constraint(equalToConstant: 150).isActive = true

//        setupRecorder()
        testWithoutMic()
    }

    private func testWithoutMic() {
        var ampl: CGFloat = 1
        let speed: CGFloat = 0.1

        func modulate() {
            ampl = Lerp.lerp(ampl, 1.5, speed)
            self.siriWave.update(ampl * 5)
        }

        _ = Timeout.setInterval(TimeInterval(speed)) {
            DispatchQueue.main.async {
                modulate()
            }
        }
    }

    /// Recorder Setup Begin
    @objc func setupRecorder() {
        if(checkMicPermission()) {
            startRecording()
        } else {
            print("permission denied")
        }
    }

    @objc func updateMeters() {
        var normalizedValue: Float
        recorder.updateMeters()
        normalizedValue = normalizedPowerLevelFromDecibels(decibels: recorder.averagePower(forChannel: 0))
        self.siriWave.update(CGFloat(normalizedValue) * 10)
    }

    private func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        let recorderSettings = [AVSampleRateKey: NSNumber(value: 44100.0),
                                AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
                                AVNumberOfChannelsKey: NSNumber(value: 2),
                                AVEncoderAudioQualityKey: NSNumber(value: Int8(AVAudioQuality.min.rawValue))]

        let url: URL = URL(fileURLWithPath:"/dev/null")
        do {

            let displayLink: CADisplayLink = CADisplayLink(target: self,
                                                           selector: #selector(updateMeters))
            displayLink.add(to: RunLoop.current,
                            forMode: RunLoop.Mode.common)

            try recordingSession.setCategory(.playAndRecord,
                                             mode: .default)
            try recordingSession.setActive(true)
            self.recorder = try AVAudioRecorder.init(url: url,
                                                     settings: recorderSettings as [String : Any])
            self.recorder.prepareToRecord()
            self.recorder.isMeteringEnabled = true;
            self.recorder.record()
            print("recorder enabled")
        } catch {
            self.showErrorPopUp(errorMessage: error.localizedDescription)
            print("recorder init failed")
        }
    }

    private func checkMicPermission() -> Bool {
        var permissionCheck: Bool = false

        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            permissionCheck = true
        case AVAudioSession.RecordPermission.denied:
            permissionCheck = false
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    permissionCheck = true
                } else {
                    permissionCheck = false
                }
            })
        default:
            break
        }

        return permissionCheck
    }

    private func normalizedPowerLevelFromDecibels(decibels: Float) -> Float {
        let minDecibels: Float = -60.0
        if (decibels < minDecibels || decibels.isZero) {
            return .zero
        }

        let powDecibels = pow(10.0, 0.05 * decibels)
        let powMinDecibels = pow(10.0, 0.05 * minDecibels)
        return pow((powDecibels - powMinDecibels) * (1.0 / (1.0 - powMinDecibels)), 1.0 / 2.0)

    }

    private func showErrorPopUp(errorMessage: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    private lazy var siriWave: SiriWaveView = {
        let siriWave = SiriWaveView()
        return siriWave
    }()
}
