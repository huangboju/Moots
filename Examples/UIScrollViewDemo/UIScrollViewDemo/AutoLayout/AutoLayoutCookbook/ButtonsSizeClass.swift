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
            bottomLayoutGuide.topAnchor.constraint(equalTo: bottomButton.bottomAnchor, constant: 20).isActive = true
            bottomButton.widthAnchor.constraint(equalTo: topButton.widthAnchor).isActive = true
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            bottomButtonLandscapeBottom = bottomLayoutGuide.topAnchor.constraint(equalTo: topButton.bottomAnchor, constant: 20)
            bottomButtonPortraitLeading = bottomButton.leadingAnchor.constraint(equalTo: topButton.trailingAnchor, constant: 8)
            topButtonLandscapeBottom = bottomButton.topAnchor.constraint(equalTo: topButton.bottomAnchor, constant: 8)
            bottomButtonLandscapeLeading = bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        }

        orientationDidChange()

        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: .UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    // MARK: - UIApplicationDidChangeStatusBarOrientationNotification
    @objc func orientationDidChange() {
        let isLandscape: Bool
        
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft, .landscapeRight:
            isLandscape = true

//            topButtonLandscapeTrailing.isActive = false
//            topButtonLandscapeBottom.isActive = false
//            bottomButtonLandscapeLeading.isActive = false
//
//            bottomButtonLandscapeBottom.isActive = true
//            bottomButtonPortraitLeading.isActive = true

        default:
            isLandscape = false

//            bottomButtonLandscapeBottom.isActive = false
//            bottomButtonPortraitLeading.isActive = false
//
//            topButtonLandscapeTrailing.isActive = true
//            topButtonLandscapeBottom.isActive = true
//            bottomButtonLandscapeLeading.isActive = true
        }

        
        // http://www.cocoachina.com/bbs/read.php?tid=111832

        // 标记为需要重新布局，异步调用layoutIfNeeded刷新布局，不立即刷新，但layoutSubviews一定会被调用
        topButton.setNeedsLayout()
        bottomButton.setNeedsLayout()
        
        // layoutIfNeeded方法：如果，有需要刷新的标记，立即调用layoutSubviews进行布局（如果没有标记，不会调用layoutSubviews

        // 这样写有警告，必须先关闭,必须加上 setNeedsLayout
        bottomButtonLandscapeBottom.isActive = isLandscape
        bottomButtonPortraitLeading.isActive = isLandscape

        topButtonLandscapeTrailing.isActive = !isLandscape
        topButtonLandscapeBottom.isActive = !isLandscape
        bottomButtonLandscapeLeading.isActive = !isLandscape
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
