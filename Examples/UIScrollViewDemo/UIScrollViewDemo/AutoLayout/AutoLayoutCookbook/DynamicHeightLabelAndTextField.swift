//
//  SimpleLabelAndTextField.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class DynamicHeightLabelAndTextField: AutoLayoutBaseController {
    var usingLargeFont = false
    
    var timer: Timer?
    
    private let titleLabel = UILabel()
    
    // MARK: UIViewController
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeFontSizeTimerDidFire), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        timer?.invalidate()
        timer = nil
    }

    // MARK: Timer
    @objc func changeFontSizeTimerDidFire(_ timer: Timer) {
        // Toggle the font preference.
        usingLargeFont = !usingLargeFont
        
        // Set the `nameLabel`'s font for the appropriate size.
        titleLabel.font =  UIFont.systemFont(ofSize: usingLargeFont ? 36.0 : 17.0)
    }

    override func initSubviews() {
        titleLabel.text = "Name"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        titleLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        let constraint = titleLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20)
        constraint.priority = UILayoutPriority(rawValue: UILayoutPriority.defaultLow.rawValue - 1)
        constraint.isActive = true

        let textField = UITextField()
        textField.placeholder = "Enter Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)

        textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        textField.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor).isActive = true
        textField.topAnchor.constraint(greaterThanOrEqualTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        let constraint1 = textField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20)
        constraint1.priority = UILayoutPriority(rawValue: UILayoutPriority.defaultLow.rawValue - 1)
        constraint1.isActive = true
    }
}

