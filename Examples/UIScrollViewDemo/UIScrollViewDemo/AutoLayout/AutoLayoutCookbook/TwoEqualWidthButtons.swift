//
//  SimpleLabelAndTextField.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class TwoEqualWidthButtons: AutoLayoutBaseController {
    override func initSubviews() {
        let leftButton = generatButton(with: "Short")
        view.addSubview(leftButton)
        leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        leftButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20).isActive = true

        let rightButton = generatButton(with: "Much Longer Button Title")
        view.addSubview(rightButton)
        rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        rightButton.widthAnchor.constraint(equalTo: leftButton.widthAnchor).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor).isActive = true
        rightButton.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 8).isActive = true
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
