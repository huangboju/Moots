import UIKit
import ReplayKit
import AVFoundation
import Photos

class ViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(contentView)
        contentView.addSubview(contentLabel)
        view.addSubview(statusLabel)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        
        NSLayoutConstraint.activate([
            // Content View
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            contentView.widthAnchor.constraint(equalToConstant: 300),
            contentView.heightAnchor.constraint(equalToConstant: 200),
            
            // Content Label
            contentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Status Label
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 40),
            
            // Start Button
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Stop Button
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            stopButton.widthAnchor.constraint(equalToConstant: 200),
            stopButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopRecording), for: .touchUpInside)
    }
    
    // MARK: - Recording Actions
    @objc private func startRecording() {
        
        ASScreenRecorder.shared.startRecording()
        statusLabel.text = "正在录制..."
        statusLabel.textColor = .systemRed
        
        if let musicURL = Bundle.main.url(forResource: "background_music", withExtension: "mp3") {
            AudioManager.shared.playMusic(from: musicURL, loop: true)
        } else {
            print("提示: 找不到音乐文件 background_music.mp3，请将音乐文件添加到项目中")
            // 可以创建一个简单的提示
        }
    }
    
    @objc private func stopRecording() {
        ASScreenRecorder.shared.stopRecording {
            AudioManager.shared.stopMusic()
            print("🍀👹👹 \(#function)")
        }
    }
    
    // MARK: - UI Components
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("开始录制", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("停止录制", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "准备就绪"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "这是要录制的内容\n录制过程中会播放音乐"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
