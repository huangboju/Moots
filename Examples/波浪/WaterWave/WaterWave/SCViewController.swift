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
            displaylink.add(to: RunLoop.current, forMode: .commonModes)
            
            waveformView.waveColor = UIColor.white
            waveformView.primaryWaveLineWidth = 3
            waveformView.secondaryWaveLineWidth = 1

            view.addSubview(waveformView)
        } catch let error {
            print(error)
        }
    }
    
    func updateMeters() {
        recorder?.updateMeters()
        // pow()用来计算以x 为底的 y 次方值，然后将结果返回。设返回值为 ret，则 ret = xy。
        let normalizedValue = pow(10, (recorder?.averagePower(forChannel: 0) ?? 0) / 20)
        waveformView.update(with: CGFloat(normalizedValue))
    }
}
