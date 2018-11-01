//
//  SizeClassSpecificLayouts.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/25.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class SizeClassSpecificLayouts: AutoLayoutBaseController {

    private var redViewTrailingConstraint: NSLayoutConstraint!
    private var redViewBottomConstraintH: NSLayoutConstraint!
    
    private var greenViewTopConstraint: NSLayoutConstraint!
    private var greenViewTopConstraintH: NSLayoutConstraint!
    
    private var greenViewLeadingConstraint: NSLayoutConstraint!
    private var greenViewLeadingConstraintH: NSLayoutConstraint!

    private var redView: UIView!
    private var greenView: UIView!

    override func initSubviews() {
        redView = generateView(with: UIColor(hex: 0xCC3300))
        view.addSubview(redView)
        
        do {
            redView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
            redViewTrailingConstraint = redView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            redViewBottomConstraintH = redView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20)
        }

        let redLabel = generatLabel(with: "Red")
        redView.addSubview(redLabel)

        do {
            redLabel.centerXAnchor.constraint(equalTo: redView.centerXAnchor).isActive = true
            redLabel.centerYAnchor.constraint(equalTo: redView.centerYAnchor).isActive = true
        }

        greenView = generateView(with: UIColor(hex: 0x1B811D))
        view.addSubview(greenView)

        do {
            greenViewTopConstraint = greenView.topAnchor.constraint(equalTo: redView.bottomAnchor, constant: 8)
            greenViewLeadingConstraintH = greenView.leadingAnchor.constraint(equalTo: redView.trailingAnchor, constant: 8)
            greenView.heightAnchor.constraint(equalTo: redView.heightAnchor).isActive = true
            greenView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            greenViewTopConstraintH = greenView.topAnchor.constraint(equalTo: redView.topAnchor)
            greenView.widthAnchor.constraint(equalTo: redView.widthAnchor).isActive = true
            greenViewLeadingConstraint = greenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
            greenView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20).isActive = true
        }

        let greenLabel = generatLabel(with: "Green")
        greenView.addSubview(greenLabel)

        do {
            greenLabel.centerXAnchor.constraint(equalTo: greenView.centerXAnchor).isActive = true
            greenLabel.centerYAnchor.constraint(equalTo: greenView.centerYAnchor).isActive = true
        }

        orientationDidChange()

        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    // MARK: - UIApplicationDidChangeStatusBarOrientationNotification
    @objc func orientationDidChange() {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft, .landscapeRight:
            
            greenViewTopConstraint.isActive = false
            redViewTrailingConstraint.isActive = false
            greenViewLeadingConstraint.isActive = false

            redViewBottomConstraintH.isActive = true
            greenViewTopConstraintH.isActive = true
            greenViewLeadingConstraintH.isActive = true
        default:
            redViewBottomConstraintH.isActive = false
            greenViewTopConstraintH.isActive = false
            greenViewLeadingConstraintH.isActive = false

            greenViewTopConstraint.isActive = true
            redViewTrailingConstraint.isActive = true
            greenViewLeadingConstraint.isActive = true
        }
    }

    private func generateView(with color: UIColor) -> UIView {
        let subview = UIView()
        subview.backgroundColor = color
        subview.translatesAutoresizingMaskIntoConstraints = false
        return subview
    }

    private func generatLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
