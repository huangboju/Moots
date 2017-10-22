//
//  SimpleLabelAndTextField.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class SimpleLabelAndTextField: AutoLayoutBaseController {
    override func initSubviews() {
        let titleLabel = UILabel()
        titleLabel.text = "Name"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        titleLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        let textField = UITextField()
        textField.placeholder = "Enter Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)

        textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        textField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        textField.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor).isActive = true
    }
}
