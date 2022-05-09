//
//  DynamicTextAndReadability.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/24.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class DynamicTextAndReadability: AutoLayoutBaseController {
    override func initSubviews() {
        let bodyTextView = UITextView()
        bodyTextView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        bodyTextView.font = UIFont.preferredFont(forTextStyle: .body)
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.isEditable = false
        view.addSubview(bodyTextView)

        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        titleLabel.text = "Lorem Ipsum"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        do {
            if #available(iOS 11, *) {
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
            } else {
                titleLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
            }
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        }
        
        do {
            bodyTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
            bodyTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
            bodyTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
            if #available(iOS 11, *) {
                bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
            } else {
                bodyTextView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20).isActive = true
            }
        }
    }
}
