//
//  CalendarEventCell.swift
//  UICollectionViewDemo
//
//  Created by 伯驹 黄 on 2017/6/1.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class CalendarEventCell: UICollectionViewCell {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.layer.cornerRadius = 5
        titleLabel.layer.backgroundColor = UIColor(red: 164 / 255, green: 215 / 255, blue: 1, alpha: 1).cgColor
        titleLabel.frame = CGRect(origin: frame.origin, size: frame.size)
        contentView.addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
