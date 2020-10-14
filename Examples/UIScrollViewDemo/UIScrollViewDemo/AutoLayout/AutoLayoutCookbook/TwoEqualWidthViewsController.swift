//
//  TwoEqualWidthViewsController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class TwoEqualWidthViewsController: AutoLayoutBaseController {
    override func initSubviews() {
        let yellowView = UIView()
        yellowView.backgroundColor = UIColor(r: 255, g: 204, b: 0)
        yellowView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(yellowView)

        if #available(iOS 11, *) {
            yellowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            yellowView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        } else {
            yellowView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
            yellowView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20).isActive = true
        }
        yellowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        let greenView = UIView()
        greenView.translatesAutoresizingMaskIntoConstraints = false
        greenView.backgroundColor = UIColor(r: 27, g: 129, b: 29)
        view.addSubview(greenView)

        greenView.widthAnchor.constraint(equalTo: yellowView.widthAnchor).isActive = true
        greenView.leadingAnchor.constraint(equalTo: yellowView.trailingAnchor, constant: 8).isActive = true
        greenView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        greenView.topAnchor.constraint(equalTo: yellowView.topAnchor).isActive = true
        greenView.bottomAnchor.constraint(equalTo: yellowView.bottomAnchor).isActive = true
    }
}
