//
//  TwoViewsWithComplexWidths.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class TwoViewsWithComplexWidths: AutoLayoutBaseController {
    override func initSubviews() {
        let blueView = UIView()
        blueView.backgroundColor = UIColor(hex: 0x3953FF)
        blueView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blueView)

        blueView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        blueView.widthAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        blueView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        blueView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20).isActive = true

        let redView = UIView()
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.backgroundColor = UIColor(hex: 0xCC3300)
        view.addSubview(redView)

        let constraint = redView.widthAnchor.constraint(equalTo: blueView.widthAnchor, multiplier: 0.5)
        constraint.priority = UILayoutPriority.defaultHigh
        constraint.isActive = true

        redView.leadingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: 8).isActive = true
        redView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        redView.topAnchor.constraint(equalTo: blueView.topAnchor).isActive = true
        redView.bottomAnchor.constraint(equalTo: blueView.bottomAnchor).isActive = true
    }
}
