//
//  SCViewController.swift
//  WaterWave
//
//  Created by 伯驹 黄 on 2017/2/9.
//  Copyright © 2017年 xiAo_Ju. All rights reserved.
//

import UIKit
import AVFoundation

class SCViewController: UIViewController {
    
    private lazy var waveformView: SCSiriWaveformView = {
        let waveformView = SCSiriWaveformView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 120))
        
        return waveformView
    }()
    
    var recorder: AVAudioRecorder?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if granted {
                DispatchQueue.main.async {
                    self.start()
                }
            } else {
                print("Permission to record not granted")
            }
        }
    }
    
    func start() {
        let url = URL(fileURLWithPath: "/dev/null")
        let settings = [
            AVSampleRateKey: NSNumber(value: 44100),
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVNumberOfChannelsKey: NSNumber(value: 2),
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)
        ]
        
        do {
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.prepareToRecord()
            recorder?.isMeteringEnabled = true
            recorder?.record()
            
            let displaylink = CADisplayLink(target: self, selector: #selector(updateMeters))
            displaylink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
            
            waveformView.waveColor = UIColor.white
            waveformView.primaryWaveLineWidth = 3
            waveformView.secondaryWaveLineWidth = 1

            view.addSubview(waveformView)
        } catch let error {
            print(error)
        }
    }
    
    @objc func updateMeters() {
        recorder?.updateMeters()
        // pow()用来计算以x 为底的 y 次方值，然后将结果返回。设返回值为 ret，则 ret = xy。
        let normalizedValue = normalizedPowerLevel(from: CGFloat(recorder?.averagePower(forChannel: 0) ?? 0))
        print("🍀👹👹 \(normalizedValue)===\(String(describing: recorder?.averagePower(forChannel: 0)))")
        waveformView.update(with: normalizedValue)
    }
    
    func normalizedPowerLevel(from decibels: CGFloat) -> CGFloat {
        if decibels < -60.0 || decibels == 0.0 {
            return 0.0
        }
        
        return pow((pow(10.0, 0.05 * decibels) - pow(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - pow(10.0, 0.05 * -60.0))), 1.0 / 2.0)
    }
}
