//
//  ImageViewsAndAspectFitMode.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/24.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class AspectRatioImageView: AutoLayoutBaseController {
    override func initSubviews() {
        let topContentView = generatContentView()
        view.addSubview(topContentView)

        let imageView = UIImageView(image: UIImage(named: "flowers"))
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        view.addSubview(imageView)

        let bottomContentView = generatContentView()
        view.addSubview(bottomContentView)
        
        let leadingContentView = generatContentView()
        view.addSubview(leadingContentView)
        
        let trailingContentView = generatContentView()
        view.addSubview(trailingContentView)
        
        do {
            if #available(iOS 11, *) {
                topContentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            } else {
                topContentView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
            }
            topContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            topContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            topContentView.heightAnchor.constraint(equalTo: bottomContentView.heightAnchor).isActive = true
        }
        
        do {
            leadingContentView.topAnchor.constraint(equalTo: topContentView.bottomAnchor, constant: 8).isActive = true
            leadingContentView.leadingAnchor.constraint(equalTo: topContentView.leadingAnchor).isActive = true
            leadingContentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        }
        
        do {
            imageView.topAnchor.constraint(equalTo: topContentView.bottomAnchor, constant: 8).isActive = true
            imageView.heightAnchor.constraint(equalTo: bottomContentView.heightAnchor, multiplier: 2).isActive = true
            imageView.leadingAnchor.constraint(equalTo: leadingContentView.trailingAnchor, constant: 8).isActive = true
        }

        do {
            trailingContentView.trailingAnchor.constraint(equalTo: topContentView.trailingAnchor).isActive = true
            trailingContentView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8).isActive = true
            trailingContentView.widthAnchor.constraint(equalTo: leadingContentView.widthAnchor).isActive = true
            trailingContentView.heightAnchor.constraint(equalTo: leadingContentView.heightAnchor).isActive = true
            trailingContentView.topAnchor.constraint(equalTo: leadingContentView.topAnchor).isActive = true
        }

        do {
            bottomContentView.trailingAnchor.constraint(equalTo: topContentView.trailingAnchor).isActive = true
            bottomContentView.leadingAnchor.constraint(equalTo: topContentView.leadingAnchor).isActive = true
            bottomContentView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
            if #available(iOS 11, *) {
                view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor, constant: 20).isActive = true
            } else {
                bottomLayoutGuide.topAnchor.constraint(equalTo: bottomContentView.bottomAnchor, constant: 20).isActive = true
            }
        }
    }
    
    private func generatContentView() -> UIView {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .lightGray
        return contentView
    }
}

