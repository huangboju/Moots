//
//  GroupingViews.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/23.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class GroupingViews: AutoLayoutBaseController {
    override func initSubviews() {
        let dummyView = generatDummyView()
        view.addSubview(dummyView)
        
        dummyView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dummyView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        let textLabel = generateLabel(with: "My Controls")
        textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        textLabel.textAlignment = .center
        dummyView.addSubview(textLabel)

        let activateLabel = generateLabel(with: "Activate")
        dummyView.addSubview(activateLabel)
        
        let skewLabel = generateLabel(with: "Skew")
        dummyView.addSubview(skewLabel)

        let switchControl1 = generateSwitch()
        dummyView.addSubview(switchControl1)


        let switchControl2 = generateSwitch()
        dummyView.addSubview(switchControl2)


        let switchControl3 = generateSwitch()
        dummyView.addSubview(switchControl3)

        let stabilizeLabel = generateLabel(with: "Stabilize")
        dummyView.addSubview(stabilizeLabel)
        
        do {
            textLabel.topAnchor.constraint(equalTo: dummyView.topAnchor).isActive = true
            textLabel.leadingAnchor.constraint(equalTo: dummyView.leadingAnchor, constant: 8).isActive = true
            dummyView.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 8).isActive = true
        }

        do {
            activateLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor).isActive = true
            switchControl1.centerYAnchor.constraint(equalTo: activateLabel.centerYAnchor).isActive = true
            switchControl1.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true
            switchControl1.leadingAnchor.constraint(equalTo: activateLabel.trailingAnchor, constant: 8).isActive = true
            switchControl1.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8).isActive = true
        }

        do {
            stabilizeLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor).isActive = true
            switchControl2.topAnchor.constraint(equalTo: switchControl1.bottomAnchor, constant: 8).isActive = true
            switchControl2.leadingAnchor.constraint(equalTo: stabilizeLabel.trailingAnchor, constant: 8).isActive = true
            switchControl2.centerYAnchor.constraint(equalTo: stabilizeLabel.centerYAnchor).isActive = true
            switchControl2.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true
        }

        do {
            skewLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor).isActive = true
            switchControl3.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true
            switchControl3.leadingAnchor.constraint(equalTo: skewLabel.trailingAnchor, constant: 8).isActive = true
            switchControl3.bottomAnchor.constraint(equalTo: dummyView.bottomAnchor).isActive = true
            switchControl3.centerYAnchor.constraint(equalTo: skewLabel.centerYAnchor).isActive = true
            switchControl3.topAnchor.constraint(equalTo: switchControl2.bottomAnchor, constant: 8).isActive = true
        }
    }

    private func generateLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func generateSwitch() -> UISwitch {
        let switchControl = UISwitch()
        switchControl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        switchControl.setContentHuggingPriority(.defaultHigh, for: .vertical)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }

    private func generatDummyView() -> UIView {
        let dummyView = UIView()
        dummyView.backgroundColor = UIColor.randomFlat()
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        return dummyView
    }

    private func generatLayoutGuide() -> UILayoutGuide {
        let layoutGuide = UILayoutGuide()
        return layoutGuide
    }
}
