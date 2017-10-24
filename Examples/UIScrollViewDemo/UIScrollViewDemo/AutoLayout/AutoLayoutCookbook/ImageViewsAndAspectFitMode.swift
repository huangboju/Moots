//
//  ImageViewsAndAspectFitMode.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/24.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class ImageViewsAndAspectFitMode: AutoLayoutBaseController {
    override func initSubviews() {
        let topContentView = generatContentView()
        view.addSubview(topContentView)
        
        let imageView = UIImageView(image: UIImage(named: "flowers"))
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        view.addSubview(imageView)

        let bottomContentView = generatContentView()
        view.addSubview(bottomContentView)

        do {
            topContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            topContentView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
            topContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            topContentView.heightAnchor.constraint(equalTo: bottomContentView.heightAnchor).isActive = true
        }

        do {
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: topContentView.bottomAnchor, constant: 8).isActive = true
            imageView.heightAnchor.constraint(equalTo: bottomContentView.heightAnchor, multiplier: 2).isActive = true
        }

        do {
            bottomContentView.trailingAnchor.constraint(equalTo: topContentView.trailingAnchor).isActive = true
            bottomContentView.leadingAnchor.constraint(equalTo: topContentView.leadingAnchor).isActive = true
            bottomContentView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
            bottomLayoutGuide.topAnchor.constraint(equalTo: bottomContentView.bottomAnchor, constant: 20).isActive = true
        }
    }
    
    private func generatContentView() -> UIView {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .lightGray
        return contentView
    }
}
