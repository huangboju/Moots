//
//  SimpleLabelAndTextField.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class EqualWhiteSpace: AutoLayoutBaseController {
    override func initSubviews() {
        let leftButton = generatButton(with: "Short")
        view.addSubview(leftButton)
        
//        let leadingDummyView = generatDummyView()
//        view.addSubview(leadingDummyView)
//
//        let centerDummyView = generatDummyView()
//        view.addSubview(centerDummyView)
//
//        let trailingDummyView = generatDummyView()
//        view.addSubview(trailingDummyView)

        let leadingDummyView = generatLayoutGuide()
        view.addLayoutGuide(leadingDummyView)

        let centerDummyView = generatLayoutGuide()
        view.addLayoutGuide(centerDummyView)

        let trailingDummyView = generatLayoutGuide()
        view.addLayoutGuide(trailingDummyView)

        let rightButton = generatButton(with: "Much Longer Button Title")
        view.addSubview(rightButton)

        do {
            leftButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16).isActive = true
            leftButton.leadingAnchor.constraint(equalTo: leadingDummyView.trailingAnchor).isActive = true
            leftButton.widthAnchor.constraint(equalTo: rightButton.widthAnchor).isActive = true
            bottomLayoutGuide.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 20).isActive = true
        }

        do {
            leadingDummyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            leadingDummyView.widthAnchor.constraint(equalTo: trailingDummyView.widthAnchor).isActive = true
            leadingDummyView.widthAnchor.constraint(equalTo: centerDummyView.widthAnchor).isActive = true
            leadingDummyView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            bottomLayoutGuide.topAnchor.constraint(equalTo: leadingDummyView.bottomAnchor, constant: 20).isActive = true
        }

        do {
            trailingDummyView.heightAnchor.constraint(equalTo: leadingDummyView.heightAnchor).isActive = true
            trailingDummyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            trailingDummyView.bottomAnchor.constraint(equalTo: leadingDummyView.bottomAnchor).isActive = true
            trailingDummyView.leadingAnchor.constraint(equalTo: rightButton.trailingAnchor).isActive = true
        }

        do {
            centerDummyView.heightAnchor.constraint(equalTo: leadingDummyView.heightAnchor).isActive = true
            centerDummyView.bottomAnchor.constraint(equalTo: leadingDummyView.bottomAnchor).isActive = true
            centerDummyView.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor).isActive = true
        }

        do {
            rightButton.leadingAnchor.constraint(equalTo: centerDummyView.trailingAnchor).isActive = true
            rightButton.leadingAnchor.constraint(greaterThanOrEqualTo: leftButton.trailingAnchor).isActive = true
            view.trailingAnchor.constraint(greaterThanOrEqualTo: rightButton.trailingAnchor, constant: 16).isActive = true
            rightButton.bottomAnchor.constraint(equalTo: leadingDummyView.bottomAnchor).isActive = true
        }
    }

    private func generatDummyView() -> UIView {
        let dummyView = UIView()
        dummyView.backgroundColor = UIColor.red
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        return dummyView
    }

    private func generatLayoutGuide() -> UILayoutGuide {
        let layoutGuide = UILayoutGuide()
        return layoutGuide
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

