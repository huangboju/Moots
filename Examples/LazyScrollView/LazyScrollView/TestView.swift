//
//  TestView.swift
//  LazyScrollView
//
//  Created by 伯驹 黄 on 2016/12/15.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class TestView: UIView {
    
    var data: String? {
        didSet {
            textLabel.text = data
        }
    }
    
    private lazy var textLabel: UILabel = {
        return UILabel(frame: self.bounds.insetBy(dx: 10, dy: 10))
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.random

        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    class var random: UIColor {
        let hue = CGFloat(Double(arc4random() % 256) / 256.0)
        let saturation = CGFloat(Double(arc4random() % 128) / 256.0 ) + 0.5
        let brightness = CGFloat(Double(arc4random() % 128) / 256.0 ) + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
