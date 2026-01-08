//
//  ASScreenRecorderVC.swift
//  UIScrollViewDemo
//
//  Created by bula on 2026/1/7.
//  Copyright © 2026 伯驹 黄. All rights reserved.
//

import UIKit

final class ASScreenRecorderVC: UIViewController {
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let playButton = UIButton(type: .custom)
    private let stopButton = UIButton(type: .custom)

    private var timer: Timer?
    private var elapsed: TimeInterval = 0
    private let duration: TimeInterval = 60 // 总时长（秒），可按需调整

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        updateUI(isRunning: false)
    }

    deinit {
        timer?.invalidate()
    }

    private func setupUI() {
        progressView.progress = 0

        playButton.setTitle("播放", for: .normal)
        playButton.layer.cornerRadius = 8
        playButton.backgroundColor = .systemGreen
        playButton.addTarget(self, action: #selector(onPlay), for: .touchUpInside)

        stopButton.setTitle("停止", for: .normal)
        stopButton.backgroundColor = .systemRed
        stopButton.layer.cornerRadius = 8
        stopButton.addTarget(self, action: #selector(onStop), for: .touchUpInside)

        let buttonsStack = UIStackView(arrangedSubviews: [playButton, stopButton])
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .fill
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 12

        [progressView, buttonsStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -24),

            buttonsStack.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16),
            buttonsStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            buttonsStack.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func onPlay() {
        if let musicURL = Bundle.main.url(forResource: "background_music", withExtension: "mp3") {
            AudioManager.shared.playMusic(from: musicURL, loop: true)
            ASScreenRecorder.shared.startRecording(AudioManager.shared.audioPlayer)
        } else {
            print("提示: 找不到音乐文件 background_music.mp3，请将音乐文件添加到项目中")
            // 可以创建一个简单的提示
        }
        startTimerIfNeeded()
        updateUI(isRunning: true)
    }

    @objc private func onStop() {
        ASScreenRecorder.shared.stopRecording {
            AudioManager.shared.stopMusic()
            print("🍀👹👹 \(#function)")
        }
        stopTimer(reset: true)
        updateUI(isRunning: false)
    }

    private func startTimerIfNeeded() {
        guard timer == nil else { return }

        // 约 60fps 更新；你也可以改成 0.1 更省电
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.elapsed = min(self.elapsed + (1.0 / 60.0), self.duration)
            self.progressView.progress = Float(self.elapsed / self.duration)

            if self.elapsed >= self.duration {
                self.stopTimer(reset: false)
                self.updateUI(isRunning: false)
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func stopTimer(reset: Bool) {
        timer?.invalidate()
        timer = nil

        if reset {
            elapsed = 0
            progressView.progress = 0
        }
    }

    private func updateUI(isRunning: Bool) {
        playButton.isEnabled = !isRunning
        stopButton.isEnabled = isRunning || progressView.progress > 0
    }
}
