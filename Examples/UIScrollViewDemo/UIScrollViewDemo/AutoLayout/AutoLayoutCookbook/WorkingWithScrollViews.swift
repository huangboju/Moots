//
//  WorkingWithScrollViews.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/24.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class WorkingWithScrollViews: AutoLayoutBaseController {
    
    private let contentView = UIView()
    
    override func initSubviews() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        do {
            scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }

        contentView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        do {
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor).isActive = true
            contentView.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor).isActive = true
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        }

        let red = UIColor(hex: 0xCC3300)
        let blue = UIColor(hex: 0x3953FF)
        let green = UIColor(hex: 0x1B811D)
        let yellow = UIColor(hex: 0xFFCC00)

        let view1 = generateView()
        view1.backgroundColor = red
        contentView.addSubview(view1)

        do {
            let widthConstraint = view1.widthAnchor.constraint(lessThanOrEqualToConstant: 80)
            widthConstraint.priority = UILayoutPriority.defaultLow
            widthConstraint.isActive = true
            view1.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true

            let heightConstraint = view1.heightAnchor.constraint(lessThanOrEqualToConstant: 80)
            heightConstraint.priority = UILayoutPriority.defaultLow
            heightConstraint.isActive = true
            view1.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true

            view1.widthAnchor.constraint(equalTo: view1.heightAnchor, multiplier: 1).isActive = true
            view1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
            view1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        }

        let view2 = generateView()
        view2.backgroundColor = blue

        do {
            view2.leadingAnchor.constraint(equalTo: view1.trailingAnchor, constant: 8).isActive = true
            view2.topAnchor.constraint(equalTo: view1.topAnchor).isActive = true
            view2.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view2.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
        }

        let view3 = generateView()
        view3.backgroundColor = green

        do {
            view3.leadingAnchor.constraint(equalTo: view2.trailingAnchor, constant: 8).isActive = true
            view3.topAnchor.constraint(equalTo: view1.topAnchor).isActive = true

            view3.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view3.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
        }

        let view4 = generateView()
        view4.backgroundColor = yellow

        do {
            view4.leadingAnchor.constraint(equalTo: view3.trailingAnchor, constant: 8).isActive = true
            view4.topAnchor.constraint(equalTo: view1.topAnchor).isActive = true
            view4.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true

            view4.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view4.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
        }

        let view5 = generateView()
        view5.backgroundColor = blue

        do {
            view5.leadingAnchor.constraint(equalTo: view1.leadingAnchor).isActive = true
            view5.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 8).isActive = true

            view5.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view5.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
        }

        let view6 = generateView()
        view6.backgroundColor = green

        do {
            view6.leadingAnchor.constraint(equalTo: view5.trailingAnchor, constant: 8).isActive = true
            view6.topAnchor.constraint(equalTo: view5.topAnchor).isActive = true

            view6.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view6.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
        }

        let view7 = generateView()
        view7.backgroundColor = yellow

        do {
            view7.leadingAnchor.constraint(equalTo: view6.trailingAnchor, constant: 8).isActive = true
            view7.topAnchor.constraint(equalTo: view5.topAnchor).isActive = true

            view7.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view7.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
        }


        let view8 = generateView()
        view8.backgroundColor = red

        do {
            view8.leadingAnchor.constraint(equalTo: view7.trailingAnchor, constant: 8).isActive = true
            view8.trailingAnchor.constraint(equalTo: view4.trailingAnchor).isActive = true
            view8.topAnchor.constraint(equalTo: view5.topAnchor).isActive = true

            view8.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view8.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
        }

        let view9 = generateView()
        view9.backgroundColor = green

        do {
            view9.leadingAnchor.constraint(equalTo: view1.leadingAnchor).isActive = true
            view9.topAnchor.constraint(equalTo: view5.bottomAnchor, constant: 8).isActive = true

            view9.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view9.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
        }

        let view10 = generateView()
        view10.backgroundColor = yellow

        do {
            view10.leadingAnchor.constraint(equalTo: view9.trailingAnchor, constant: 8).isActive = true
            view10.topAnchor.constraint(equalTo: view9.topAnchor).isActive = true

            view10.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view10.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
        }

        let view11 = generateView()
        view11.backgroundColor = red

        do {
            view11.leadingAnchor.constraint(equalTo: view10.trailingAnchor, constant: 8).isActive = true
            view11.topAnchor.constraint(equalTo: view9.topAnchor).isActive = true

            view11.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view11.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
        }

        let view12 = generateView()
        view12.backgroundColor = blue

        do {
            view12.leadingAnchor.constraint(equalTo: view11.trailingAnchor, constant: 8).isActive = true
            view12.trailingAnchor.constraint(equalTo: view4.trailingAnchor).isActive = true
            view12.topAnchor.constraint(equalTo: view9.topAnchor).isActive = true

            view12.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view12.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
        }

        let view13 = generateView()
        view13.backgroundColor = yellow

        do {
            view13.leadingAnchor.constraint(equalTo: view1.leadingAnchor).isActive = true
            view13.topAnchor.constraint(equalTo: view9.bottomAnchor, constant: 8).isActive = true

            view13.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view13.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
            view13.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        }

        let view14 = generateView()
        view14.backgroundColor = red

        do {
            view14.leadingAnchor.constraint(equalTo: view13.trailingAnchor, constant: 8).isActive = true
            view14.topAnchor.constraint(equalTo: view13.topAnchor).isActive = true

            view14.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view14.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
            
            view14.bottomAnchor.constraint(equalTo: view13.bottomAnchor).isActive = true
        }

        let view15 = generateView()
        view15.backgroundColor = blue

        do {
            view15.leadingAnchor.constraint(equalTo: view14.trailingAnchor, constant: 8).isActive = true
            view15.topAnchor.constraint(equalTo: view13.topAnchor).isActive = true

            view15.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view15.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
            
            view15.bottomAnchor.constraint(equalTo: view13.bottomAnchor).isActive = true
        }

        let view16 = generateView()
        view16.backgroundColor = green

        do {
            view16.leadingAnchor.constraint(equalTo: view15.trailingAnchor, constant: 8).isActive = true
            view16.topAnchor.constraint(equalTo: view13.topAnchor).isActive = true
            view16.trailingAnchor.constraint(equalTo: view4.trailingAnchor).isActive = true

            view16.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
            view16.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
            
            view16.bottomAnchor.constraint(equalTo: view13.bottomAnchor).isActive = true
        }
    }
    
    private func generateView() -> UIView {
        let subview = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subview)

        return subview
    }
}
