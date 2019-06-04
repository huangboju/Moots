//
//  NestedStackViewController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

// https://www.mgenware.com/blog/?p=491

// http://www.devtalking.com/articles/uistackview/

// setContentHuggingPriority
// Content Hugging Priority代表控件拒绝拉伸的优先级。优先级越高，控件会越不容易被拉伸。


// setContentCompressionResistancePriority
// Content Compression Resistance Priority代表控件拒绝压缩内置空间的优先级。优先级越高，控件的内置空间会越不容易被压缩

class NestedStackViewController: AutoLayoutBaseController {

    override func initSubviews() {
        let inputViews = generatInputViews()
        
        let textView = UITextView()
        textView.backgroundColor = .gray
        textView.text = "Notes:"

        let buttons = generatButtons()

        let mainStackView = UIStackView(arrangedSubviews: [inputViews, textView, buttons])
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)

        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        mainStackView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: 100).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor, constant: -60).isActive = true
    }

    private var normalStackView: UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }
    
    private func generatInputViews() -> UIStackView {
        let contentStackView = UIStackView()
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        let items = [
            ("First", "Enter First Name"),
            ("Middle", "Enter Middle Name"),
            ("Last", "Enter Last Name")
        ]

        let imageView = UIImageView()
        
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 48), for: .horizontal)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 48), for: .vertical)

        imageView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        imageView.image = UIImage(named: "square_flowers")
        contentStackView.addArrangedSubview(imageView)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
        // 等同上面一句
//        imageView.addConstraint(NSLayoutConstraint(item: imageView,
//                                                   attribute: .height,
//                                                   relatedBy: .equal,
//                                                   toItem: imageView,
//                                                   attribute: .width,
//                                                   multiplier: 1,
//                                                   constant: 0))

        let fieldsStackView = normalStackView
        fieldsStackView.spacing = 8
        contentStackView.addArrangedSubview(fieldsStackView)
        var tempFiled: UITextField?
        for item in items {

            let titleLabel = UILabel()
            titleLabel.backgroundColor = UIColor.red
            titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
            titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
//            titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
//            titleLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
//            titleLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .vertical)
            titleLabel.text = item.0

            let superStackView = UIStackView(arrangedSubviews: [titleLabel])
            superStackView.axis = .horizontal
            superStackView.alignment = .firstBaseline
            superStackView.spacing = 8
            superStackView.distribution = .fill

            fieldsStackView.addArrangedSubview(superStackView)

            let field = UITextField()
            superStackView.addArrangedSubview(field)
            field.borderStyle = .roundedRect
            field.setContentHuggingPriority(UILayoutPriority(rawValue: 48), for: .horizontal)
            field.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: .horizontal)
            field.placeholder = item.1
            field.translatesAutoresizingMaskIntoConstraints = false
            if let tempFiled = tempFiled {
                field.widthAnchor.constraint(equalTo: tempFiled.widthAnchor).isActive = true
            }
            tempFiled = field
        }

        return contentStackView
    }

    private func generatButtons() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.distribution = .fillEqually
        stackView.spacing = 8

        let titles = ["Save", "Cancel", "Clear"]
        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            stackView.addArrangedSubview(button)
        }

        return stackView
    }
}
