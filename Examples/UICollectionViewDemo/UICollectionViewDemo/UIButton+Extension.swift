//
//  UIButton+Extension.swift
//  UICollectionViewDemo
//
//  Created by 伯驹 黄 on 2016/12/7.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

extension UIButton {

    func set(_ title: String?, with image: UIImage?, direction: NSLayoutAttribute = .top, interval: CGFloat = 10.0) {
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        adjustsImageWhenHighlighted = false
        titleLabel?.backgroundColor = backgroundColor
        imageView?.backgroundColor = backgroundColor
        guard let titleSize = titleLabel?.bounds.size, let imageSize = imageView?.bounds.size else {
            return
        }
        let horizontal = (frame.width - titleSize.width - imageSize.width - interval) / 2
         let h = imageSize.height + interval
        let vertical = (frame.height - titleSize.height - h) / 2
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        if let constraints = imageView?.superview?.constraints {
            imageView?.superview?.removeConstraints(constraints)
        }
        switch direction {
        case .left, .right:
            let centerY = NSLayoutConstraint(item: imageView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)

            let isRight = direction == .right
            let constraint = NSLayoutConstraint(item: imageView!, attribute: direction, relatedBy: .equal, toItem: self, attribute: direction, multiplier: 1, constant: horizontal * (isRight ? -1 : 1))
            imageView?.superview?.addConstraints([centerY, constraint])

            let offsetX = isRight ? -(0.5 * interval + imageSize.width) * 2 : interval
            titleEdgeInsets = UIEdgeInsets(top: 0, left: offsetX, bottom: 0, right: 0)
        case .bottom, .top:
            let value: CGFloat = direction == .top ? 1 : -1

            let centerX = NSLayoutConstraint(item: imageView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)

            let constraint = NSLayoutConstraint(item: imageView!, attribute: direction, relatedBy: .equal, toItem: self, attribute: direction, multiplier: 1, constant: vertical * value)
            imageView?.superview?.addConstraints([centerX, constraint])

            titleEdgeInsets = UIEdgeInsets(top: h * value, left: -imageSize.width, bottom: 0, right: 0)
        default:
            fatalError("方向不匹配")
        }
    }
}
