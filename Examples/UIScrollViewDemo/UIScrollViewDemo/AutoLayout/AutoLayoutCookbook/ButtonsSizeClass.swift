//
//  ButtonsSizeClass.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/23.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class ButtonsSizeClass: AutoLayoutBaseController {
    
    var topButton: UIButton!
    var bottomButton: UIButton!
    
    var bottomButtonLandscapeBottom: NSLayoutConstraint!
    var bottomButtonPortraitLeading: NSLayoutConstraint!
    var bottomButtonLandscapeLeading: NSLayoutConstraint!
    
    var topButtonLandscapeTrailing: NSLayoutConstraint!
    var topButtonLandscapeBottom: NSLayoutConstraint!
    
    override func initSubviews() {
        topButton = generatButton(with: "Short")
        view.addSubview(topButton)

        bottomButton = generatButton(with: "Much Longer Button Title")
        view.addSubview(bottomButton)

        do {
            topButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            topButtonLandscapeTrailing = topButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        }

        do {
            if #available(iOS 11, *) {
                view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomButton.bottomAnchor, constant: 20).isActive = true
                bottomButtonLandscapeBottom = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: topButton.bottomAnchor, constant: 20)
            } else {
                bottomLayoutGuide.topAnchor.constraint(equalTo: bottomButton.bottomAnchor, constant: 20).isActive = true
                bottomButtonLandscapeBottom = bottomLayoutGuide.topAnchor.constraint(equalTo: topButton.bottomAnchor, constant: 20)
            }
            bottomButton.widthAnchor.constraint(equalTo: topButton.widthAnchor).isActive = true
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            bottomButtonPortraitLeading = bottomButton.leadingAnchor.constraint(equalTo: topButton.trailingAnchor, constant: 8)
            topButtonLandscapeBottom = bottomButton.topAnchor.constraint(equalTo: topButton.bottomAnchor, constant: 8)
            bottomButtonLandscapeLeading = bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        }

        orientationDidChange()

        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    // MARK: - UIApplicationDidChangeStatusBarOrientationNotification
    @objc func orientationDidChange() {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft, .landscapeRight:
            topButtonLandscapeTrailing.isActive = false
            topButtonLandscapeBottom.isActive = false
            bottomButtonLandscapeLeading.isActive = false

            bottomButtonLandscapeBottom.isActive = true
            bottomButtonPortraitLeading.isActive = true

        default:
            bottomButtonLandscapeBottom.isActive = false
            bottomButtonPortraitLeading.isActive = false

            topButtonLandscapeTrailing.isActive = true
            topButtonLandscapeBottom.isActive = true
            bottomButtonLandscapeLeading.isActive = true
        }

        
        // http://www.cocoachina.com/bbs/read.php?tid=111832

        // 标记为需要重新布局，异步调用layoutIfNeeded刷新布局，不立即刷新，但layoutSubviews一定会被调用
//
//        // layoutIfNeeded方法：如果，有需要刷新的标记，立即调用layoutSubviews进行布局（如果没有标记，不会调用layoutSubviews
    }

    private func generatButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
