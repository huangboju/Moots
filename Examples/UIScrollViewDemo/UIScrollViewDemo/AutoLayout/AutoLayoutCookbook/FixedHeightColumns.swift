//
//  SimpleLabelAndTextField.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class FixedHeightColumns: AutoLayoutBaseController {
    
    override func initSubviews() {
        let firstLabel = generatLabel(with: "First Name")
        view.addSubview(firstLabel)
        firstLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        let firstField = generatField(with: "Enter First Name")
        view.addSubview(firstField)
        firstField.lastBaselineAnchor.constraint(equalTo: firstLabel.lastBaselineAnchor).isActive = true
        firstField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        firstField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        firstField.leadingAnchor.constraint(equalTo: firstLabel.trailingAnchor, constant: 8).isActive = true
        
        let middleLabel = generatLabel(with: "Middle Name")
        view.addSubview(middleLabel)
        middleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        let middleField = generatField(with: "Enter Middle Name")
        view.addSubview(middleField)
        middleField.leadingAnchor.constraint(equalTo: middleLabel.trailingAnchor, constant: 8).isActive = true
        middleField.lastBaselineAnchor.constraint(equalTo: middleLabel.lastBaselineAnchor).isActive = true
        middleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        middleField.topAnchor.constraint(equalTo: firstField.bottomAnchor, constant: 8).isActive = true
        middleField.widthAnchor.constraint(equalTo: firstField.widthAnchor).isActive = true

        let lastLabel = generatLabel(with: "Last Name")
        view.addSubview(lastLabel)
        lastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        let lastField = generatField(with: "Enter Last Name")
        view.addSubview(lastField)
        lastField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        lastField.topAnchor.constraint(equalTo: middleField.bottomAnchor, constant: 8).isActive = true
        lastField.widthAnchor.constraint(equalTo: firstField.widthAnchor).isActive = true
        lastField.leadingAnchor.constraint(equalTo: lastLabel.trailingAnchor, constant: 8).isActive = true
        lastField.lastBaselineAnchor.constraint(equalTo: lastLabel.lastBaselineAnchor).isActive = true
    }

    private func generatLabel(with title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        titleLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }

    private func generatField(with placeholder: String) -> UITextField {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = placeholder
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
}


