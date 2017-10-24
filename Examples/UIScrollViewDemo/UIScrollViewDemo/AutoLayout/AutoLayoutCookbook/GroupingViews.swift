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
        
        let switchControl1 = UISwitch()
        dummyView.addSubview(switchControl1)
        
        let stabilizeLabel = generateLabel(with: "Stabilize")
        dummyView.addSubview(stabilizeLabel)


        let switchControl2 = UISwitch()
        dummyView.addSubview(switchControl2)

        let skewLabel = generateLabel(with: "Skew")
        dummyView.addSubview(skewLabel)
        
        let switchControl3 = UISwitch()
        dummyView.addSubview(switchControl3)
        
        do {
            textLabel.topAnchor.constraint(equalTo: dummyView.topAnchor).isActive = true
            textLabel.leadingAnchor.constraint(equalTo: dummyView.leadingAnchor).isActive = true
            textLabel.trailingAnchor.constraint(equalTo: dummyView.trailingAnchor).isActive = true
        }
        
        do {
            activateLabel.leadingAnchor.constraint(equalTo: dummyView.leadingAnchor).isActive = true
            switchControl1.centerYAnchor.constraint(equalTo: activateLabel.centerYAnchor).isActive = true
            switchControl1.trailingAnchor.constraint(equalTo: dummyView.trailingAnchor).isActive = true
            switchControl1.leadingAnchor.constraint(equalTo: activateLabel.trailingAnchor).isActive = true
            switchControl1.topAnchor.constraint(equalTo: dummyView.bottomAnchor).isActive = true
        }
        
        do {
            switchControl2.topAnchor.constraint(equalTo: switchControl1.bottomAnchor).isActive = true
        }
        
        do {
            stabilizeLabel.leadingAnchor.constraint(equalTo: dummyView.leadingAnchor).isActive = true
        }
    }

    private func generateLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
