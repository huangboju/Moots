//
//  UIButton+Extension.swift
//  UICollectionViewDemo
//
//  Created by 伯驹 黄 on 2016/12/7.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

extension UIButton {
    // FIXME: 横向不完美
    func setButton(title: String?, image: UIImage?, direction: IconDirection = .Top, interval: CGFloat = 10.0) {
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        adjustsImageWhenHighlighted = false
        titleLabel?.backgroundColor = backgroundColor
        imageView?.backgroundColor = backgroundColor
        guard let titleSize = titleLabel?.bounds.size, let imageSize = imageView?.bounds.size else {
            return
        }
        let horizontal = (frame.width - max(titleSize.width, imageSize.width) - interval) / 2
        let vertical = (frame.height - titleSize.height - imageSize.height - interval) / 2
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        if let constraints = imageView?.superview?.constraints {
            imageView?.superview?.removeConstraints(constraints)
        }
        switch direction {
        case .Left:
            let centerY = NSLayoutConstraint(item: imageView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            let left = NSLayoutConstraint(item: imageView!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: horizontal)
            imageView?.superview?.addConstraints([centerY, left])
            titleEdgeInsets = UIEdgeInsets(top: 0, left: interval, bottom: 0, right: 0)
        case .Bottom:
            let centerX = NSLayoutConstraint(item: imageView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: imageView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -vertical)
            imageView?.superview?.addConstraints([centerX, bottom])
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: imageSize.height + interval, right: 0)
        case .Right:
            let centerY = NSLayoutConstraint(item: imageView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: imageView!, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -horizontal)
            imageView?.superview?.addConstraints([centerY, right])
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + interval), bottom: 0, right: imageSize.width + interval + horizontal)
        case .Top:
            let centerX = NSLayoutConstraint(item: imageView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: imageView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: vertical)
            imageView?.superview?.addConstraints([centerX, top])
            titleEdgeInsets = UIEdgeInsets(top: imageSize.height + interval, left: -imageSize.width, bottom: 0, right: 0)
        }
    }
}
