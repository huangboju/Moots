//
//  IconLabelCell.swift
//  UICollectionViewDemo
//
//  Created by 伯驹 黄 on 2016/12/7.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class IconLabelCell: UICollectionViewCell {
    
    var direction: NSLayoutAttribute? {
        didSet {
            if let direction = direction {
                button.set("知乎日报", with: UIImage(named: "icon"), direction: direction)
            }
        }
    }

    private lazy var button: UIButton = {
        return UIButton(frame: self.bounds)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.adjustsImageWhenHighlighted = false
        contentView.addSubview(button)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
