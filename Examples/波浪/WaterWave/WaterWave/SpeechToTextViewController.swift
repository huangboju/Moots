//
//  SpeechToTextViewController.swift
//  WaterWave
//
//  Created by bula on 2025/7/16.
//  Copyright © 2025 xiAo_Ju. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class SpeechToTextViewController: UIViewController {
    
    // MARK: - 语音识别相关
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // MARK: - 状态管理
    private var isRecording = false
    private var lastVolumeUpdateTime: TimeInterval = 0
    
    // MARK: - UI 元素
    private lazy var waveformView: SCSiriWaveformView = {
        let view = SCSiriWaveformView()
        view.backgroundColor = UIColor.black
        view.waveColor = UIColor.white
        view.numberOfWaves = 2
        view.primaryWaveLineWidth = 1
        view.secondaryWaveLineWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var transcriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.isEditable = false
        textView.text = "识别的文字将在这里显示..."
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var recordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("开始语音识别", for: .normal)
        button.setTitle("停止识别", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "点击开始语音识别"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("清除文本", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor.systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAudioSession()
        requestPermissions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopRecording()
    }
    
    // MARK: - UI 设置
    private func setupUI() {
        view.backgroundColor = .black
        title = "语音转文字"
        
        view.addSubview(waveformView)
        view.addSubview(transcriptionTextView)
        view.addSubview(recordButton)
        view.addSubview(statusLabel)
        view.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            // 波形视图
            waveformView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            waveformView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            waveformView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            waveformView.heightAnchor.constraint(equalToConstant: 150),
            
            // 文字显示区域
            transcriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transcriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            transcriptionTextView.topAnchor.constraint(equalTo: waveformView.bottomAnchor, constant: 20),
            transcriptionTextView.heightAnchor.constraint(equalToConstant: 200),
            
            // 状态标签
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusLabel.topAnchor.constraint(equalTo: transcriptionTextView.bottomAnchor, constant: 20),
            
            // 录音按钮
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 30),
            recordButton.widthAnchor.constraint(equalToConstant: 180),
            recordButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 清除按钮
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 20),
            clearButton.widthAnchor.constraint(equalToConstant: 120),
            clearButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // MARK: - 音频设置
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("音频会话设置失败: \(error)")
        }
    }
    
    // MARK: - 权限请求
    private func requestPermissions() {
        // 请求语音识别权限
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self?.statusLabel.text = "语音识别权限已获取"
                case .denied:
                    self?.statusLabel.text = "语音识别权限被拒绝"
                case .restricted:
                    self?.statusLabel.text = "语音识别权限受限"
                case .notDetermined:
                    self?.statusLabel.text = "语音识别权限未确定"
                @unknown default:
                    self?.statusLabel.text = "未知权限状态"
                }
            }
        }
        
        // 请求麦克风权限
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.statusLabel.text = "权限已获取，可以开始语音识别"
                } else {
                    self?.statusLabel.text = "需要麦克风权限"
                }
            }
        }
    }
    
    // MARK: - 语音识别控制
    @objc private func recordButtonTapped() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        // 检查权限
        guard SFSpeechRecognizer.authorizationStatus() == .authorized,
              AVAudioSession.sharedInstance().recordPermission == .granted else {
            statusLabel.text = "请检查麦克风和语音识别权限"
            return
        }
        
        // 停止之前的识别任务
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        // 准备音频引擎
        let inputNode = audioEngine.inputNode
        
        // 创建识别请求
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("无法创建 SFSpeechAudioBufferRecognitionRequest 对象")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // 开始识别任务
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            var isFinal = false
            
            if let result = result {
                DispatchQueue.main.async {
                    self?.transcriptionTextView.text = result.bestTranscription.formattedString
                    self?.statusLabel.text = "识别中..."
                }
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                DispatchQueue.main.async {
                    self?.statusLabel.text = isFinal ? "识别完成" : "识别出错"
                }
            }
        }
        
        // 设置音频格式
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        // 安装音量监听节点
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, when in
            // 添加缓冲区到识别请求
            recognitionRequest.append(buffer)
            
            // 计算音量强度
            self?.processAudioBuffer(buffer)
        }
        
        // 准备和启动音频引擎
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            isRecording = true
            recordButton.isSelected = true
            recordButton.backgroundColor = UIColor.systemGreen
            statusLabel.text = "正在录音和识别..."
        } catch {
            print("音频引擎启动失败: \(error)")
            statusLabel.text = "录音启动失败"
        }
    }
    
    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        recognitionTask?.cancel()
        recognitionTask = nil
        
        isRecording = false
        recordButton.isSelected = false
        recordButton.backgroundColor = UIColor.systemRed
        statusLabel.text = "已停止录音"
    }
    
    // MARK: - 音量处理
    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        
        let channelDataValue = channelData
        let channelDataValueArray = stride(from: 0, to: Int(buffer.frameLength), by: buffer.stride).map { channelDataValue[$0] }
        
        // 计算RMS (Root Mean Square) 音量
        let rms = sqrt(channelDataValueArray.map { $0 * $0 }.reduce(0, +) / Float(channelDataValueArray.count))
        
        // 转换为分贝并标准化
        var decibels: Float = 20 * log10(rms)
        if decibels < -60 { decibels = -60 }
        if decibels > 0 { decibels = 0 }
        
        let normalizedVolume = (decibels + 60) / 60.0 // 标准化到 0-1 范围
        
                 // 节流更新频率（避免过于频繁的UI更新）
         let currentTime = CACurrentMediaTime()
//         if currentTime - lastVolumeUpdateTime > 0.05 { // 每50ms更新一次
             DispatchQueue.main.async { [weak self] in
                 self?.waveformView.update(with: CGFloat(normalizedVolume))
             }
             lastVolumeUpdateTime = currentTime
//         }
    }
    
    // MARK: - 按钮动作
    @objc private func clearButtonTapped() {
        transcriptionTextView.text = "识别的文字将在这里显示..."
        statusLabel.text = "文本已清除"
    }
}

// MARK: - 错误处理扩展
extension SpeechToTextViewController {
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
} 
