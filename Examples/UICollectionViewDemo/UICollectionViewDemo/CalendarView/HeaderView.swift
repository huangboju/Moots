//
//  HeaderView.swift
//  UICollectionViewDemo
//
//  Created by 伯驹 黄 on 2017/6/1.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    let titleLabel = UILabel()
    
    let line = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.frame = CGRect(x: 10, y: 10, width: frame.width - 20, height: 21)

        addSubview(titleLabel)

        line.backgroundColor = UIColor(red: 127 / 255, green: 127 / 255, blue: 127 / 255, alpha: 1).cgColor
        layer.addSublayer(line)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        line.frame = CGRect(x: 0, y: frame.height - 0.5, width: frame.width, height: 0.5)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
