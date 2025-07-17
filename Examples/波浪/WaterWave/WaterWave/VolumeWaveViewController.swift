//
//  VolumeWaveViewController.swift
//  WaterWave
//
//  Created by bula on 2025/7/16.
//  Copyright © 2025 xiAo_Ju. All rights reserved.
//

import AVFoundation
import UIKit

class VolumeWaveViewController: UIViewController {
    
    private var recorder: AVAudioRecorder?
    private var displayLink: CADisplayLink?
    private var isRecording = false
    
    // MARK: - UI 元素
    private lazy var volumeWaveView: VolumeWaveView = {
        let view = VolumeWaveView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var controlButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("开始录音", for: .normal)
        button.setTitle("停止录音", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(controlButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var simulationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("模拟音量变化", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(simulationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var customizationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAudioSession()
        startSimulation() // 默认开始模拟
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopRecording()
        stopSimulation()
    }
    
    // MARK: - UI 设置
    private func setupUI() {
        view.backgroundColor = .black
        title = "音量波形可视化"
        
        // 添加子视图
        view.addSubview(volumeWaveView)
        view.addSubview(controlButton)
        view.addSubview(simulationButton)
        view.addSubview(customizationStackView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 波形视图
            volumeWaveView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            volumeWaveView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            volumeWaveView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            volumeWaveView.heightAnchor.constraint(equalToConstant: 200),
            
            // 控制按钮
            controlButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            controlButton.topAnchor.constraint(equalTo: volumeWaveView.bottomAnchor, constant: 30),
            controlButton.widthAnchor.constraint(equalToConstant: 120),
            controlButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 模拟按钮
            simulationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80),
            simulationButton.topAnchor.constraint(equalTo: volumeWaveView.bottomAnchor, constant: 30),
            simulationButton.widthAnchor.constraint(equalToConstant: 120),
            simulationButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 自定义控件
            customizationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customizationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customizationStackView.topAnchor.constraint(equalTo: controlButton.bottomAnchor, constant: 30),
            customizationStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        setupCustomizationControls()
    }
    
    private func setupCustomizationControls() {
        // 频率调节
        let frequencyControl = createSliderControl(
            title: "频率",
            value: Float(volumeWaveView.frequency),
            minimumValue: 0.5,
            maximumValue: 3.0
        ) { [weak self] value in
            self?.volumeWaveView.frequency = CGFloat(value)
        }
        
        // 相位速度调节
        let phaseSpeedControl = createSliderControl(
            title: "动画速度",
            value: abs(Float(volumeWaveView.phaseShift)),
            minimumValue: 0.02,
            maximumValue: 0.3
        ) { [weak self] value in
            self?.volumeWaveView.phaseShift = -CGFloat(value)
        }
        
        customizationStackView.addArrangedSubview(frequencyControl)
        customizationStackView.addArrangedSubview(phaseSpeedControl)
    }
    
    private func createSliderControl(title: String, value: Float, minimumValue: Float, maximumValue: Float, onChange: @escaping (Float) -> Void) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let slider = UISlider()
        slider.value = value
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        // 存储回调
        slider.tag = containerView.hashValue
        objc_setAssociatedObject(slider, &sliderCallbackKey, onChange, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        containerView.addSubview(label)
        containerView.addSubview(slider)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.widthAnchor.constraint(equalToConstant: 80),
            
            slider.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
            slider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            slider.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            
            containerView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        return containerView
    }
    
    // MARK: - 音频设置
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("音频会话设置失败: \(error)")
        }
    }
    
    // MARK: - 录音控制
    @objc private func controlButtonTapped() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        guard checkMicrophonePermission() else {
            showPermissionAlert()
            return
        }
        
        stopSimulation() // 停止模拟
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsPath.appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            recorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            recorder?.record()
            
            // 开始更新音量
            displayLink = CADisplayLink(target: self, selector: #selector(updateVolumeFromMicrophone))
            displayLink?.add(to: .current, forMode: .default)
            
            isRecording = true
            controlButton.isSelected = true
            
        } catch {
            print("录音启动失败: \(error)")
        }
    }
    
    private func stopRecording() {
        recorder?.stop()
        recorder = nil
        displayLink?.invalidate()
        displayLink = nil
        
        isRecording = false
        controlButton.isSelected = false
    }
    
    @objc private func updateVolumeFromMicrophone() {
        guard let recorder = recorder else { return }
        
        recorder.updateMeters()
        let averagePower = recorder.averagePower(forChannel: 0)
        let normalizedVolume = normalizedPowerLevel(from: averagePower)
        
        DispatchQueue.main.async {
            self.volumeWaveView.updateVolume(CGFloat(normalizedVolume))
        }
    }
    
    private func normalizedPowerLevel(from decibels: Float) -> Float {
        let minDecibels: Float = -60.0
        if decibels < minDecibels {
            return 0.0
        }
        
        let normalizedValue = (decibels - minDecibels) / (0.0 - minDecibels)
        return min(max(normalizedValue, 0.0), 1.0)
    }
    
    // MARK: - 模拟音量变化
    @objc private func simulationButtonTapped() {
        if displayLink?.isPaused == false {
            stopSimulation()
        } else {
            startSimulation()
        }
    }
    
    private func startSimulation() {
        stopRecording() // 停止录音
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateSimulatedVolume))
        displayLink?.add(to: .current, forMode: .default)
        
        simulationButton.setTitle("停止模拟", for: .normal)
        simulationButton.backgroundColor = .systemRed
    }
    
    private func stopSimulation() {
        displayLink?.invalidate()
        displayLink = nil
        
        simulationButton.setTitle("模拟音量变化", for: .normal)
        simulationButton.backgroundColor = .systemGreen
    }
    
    @objc private func updateSimulatedVolume() {
        let time = CACurrentMediaTime()
        // 创建复合的音量变化模式
        let volume1 = sin(time * 1.5) * 0.5 + 0.5
        let volume2 = sin(time * 0.8 + 1.0) * 0.3
        let volume3 = sin(time * 2.1 + 2.0) * 0.2
        
        let combinedVolume = (volume1 + volume2 + volume3) / 3.0
        let normalizedVolume = max(0.0, min(1.0, combinedVolume))
        
        volumeWaveView.updateVolume(CGFloat(normalizedVolume))
    }
    
    // MARK: - 权限检查
    private func checkMicrophonePermission() -> Bool {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            return true
        case .denied:
            return false
        case .undetermined:
            return false
        @unknown default:
            return false
        }
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "需要麦克风权限",
            message: "请在设置中允许访问麦克风以使用录音功能",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "设置", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - 滑块控制
    @objc private func sliderValueChanged(_ slider: UISlider) {
        if let callback = objc_getAssociatedObject(slider, &sliderCallbackKey) as? (Float) -> Void {
            callback(slider.value)
        }
    }
}

// MARK: - 关联对象键
private var sliderCallbackKey: UInt8 = 0 
