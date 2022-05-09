//
//  SimpleLabelAndTextField.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class ThreeEqualWidthButtons: AutoLayoutBaseController {
    override func initSubviews() {
        
        let firstButton = generatButton(with: "Short")
        view.addSubview(firstButton)
        firstButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        if #available(iOS 11, *) {
            firstButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        } else {
            firstButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20).isActive = true
        }
        
        let middleButton = generatButton(with: "Medium")
        view.addSubview(middleButton)
        middleButton.widthAnchor.constraint(equalTo: firstButton.widthAnchor).isActive = true
        middleButton.centerYAnchor.constraint(equalTo: firstButton.centerYAnchor).isActive = true
        middleButton.leadingAnchor.constraint(equalTo: firstButton.trailingAnchor, constant: 8).isActive = true

        let lastButton = generatButton(with: "Much Longer Button Title")
        view.addSubview(lastButton)
        lastButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        lastButton.widthAnchor.constraint(equalTo: firstButton.widthAnchor).isActive = true
        lastButton.centerYAnchor.constraint(equalTo: firstButton.centerYAnchor).isActive = true
        lastButton.leadingAnchor.constraint(equalTo: middleButton.trailingAnchor, constant: 8).isActive = true
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

