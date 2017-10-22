//
//  SimpleStackViewController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class SimpleStackViewController: AutoLayoutBaseController {
    
    override func initSubviews() {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        view.addSubview(stackView)

        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: 100).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = "Flowers"
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)

        let imageView = UIImageView()
        stackView.addArrangedSubview(imageView)
        imageView.image = UIImage(named: "flowers")

        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        stackView.addArrangedSubview(button)
    }
}
