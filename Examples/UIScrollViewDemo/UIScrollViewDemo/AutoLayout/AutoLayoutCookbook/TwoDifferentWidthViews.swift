//
//  TwoDifferentWidthViews.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class TwoDifferentWidthViews: AutoLayoutBaseController {
    override func initSubviews() {
        let purpleView = UIView()
        purpleView.backgroundColor = UIColor(r: 146, g: 39, b: 143)
        purpleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(purpleView)
        
        if #available(iOS 11, *) {
            purpleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            purpleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        } else {
            purpleView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
            purpleView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20).isActive = true
        }
        
        purpleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        let orangeView = UIView()
        orangeView.translatesAutoresizingMaskIntoConstraints = false
        orangeView.backgroundColor = UIColor(r: 27, g: 129, b: 29)
        view.addSubview(orangeView)
        
        orangeView.widthAnchor.constraint(equalTo: purpleView.widthAnchor, multiplier: 2).isActive = true
        orangeView.leadingAnchor.constraint(equalTo: purpleView.trailingAnchor, constant: 8).isActive = true
        orangeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        orangeView.topAnchor.constraint(equalTo: purpleView.topAnchor).isActive = true
        orangeView.bottomAnchor.constraint(equalTo: purpleView.bottomAnchor).isActive = true
    }
}
