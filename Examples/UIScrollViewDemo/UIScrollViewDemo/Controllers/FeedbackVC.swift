//
//  FeedbackVC.swift
//  UIScrollViewDemo
//
//  Created by bula on 2025/10/30.
//  Copyright © 2025 伯驹 黄. All rights reserved.
//

import Foundation
import SnapKit
import AVFoundation

class FeedbackVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let list = [
            "UINotificationFeedbackGenerator error",
            "UINotificationFeedbackGenerator success",
            "UINotificationFeedbackGenerator warning",
            "UINotificationFeedbackGenerator light",
            "UINotificationFeedbackGenerator medium",
            "UINotificationFeedbackGenerator heavy",
            "UISelectionFeedbackGenerator",
            "AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)",
            "AudioServicesPlaySystemSound(1519)",
            "AudioServicesPlaySystemSound(1520)",
            "AudioServicesPlaySystemSound(1521)"
        ]
        
        let buttons = list.map {
            let button = UIButton()
            button.setTitle($0, for: .normal)
            button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
            button.backgroundColor = UIColor.random
            return button
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.spacing = 12
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func tapped(_ sender: UIButton) {
        let title = sender.title(for: .normal) ?? ""
        switch title {
        case "UINotificationFeedbackGenerator error":
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case "UINotificationFeedbackGenerator success":
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case "UINotificationFeedbackGenerator warning":
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case "UIImpactFeedbackGenerator light":
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case "UIImpactFeedbackGenerator medium":
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case "UIImpactFeedbackGenerator heavy":
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case "AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)":
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        case "AudioServicesPlaySystemSound(1519)":
            AudioServicesPlaySystemSound(1519)
        case "AudioServicesPlaySystemSound(1520)":
            AudioServicesPlaySystemSound(1520)
        case "AudioServicesPlaySystemSound(1521)":
            AudioServicesPlaySystemSound(1521)
        default:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}
