//
//  MyCoRightsCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MyCoRightsCell: UITableViewCell {
    
    private lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor(hex: 0x4A4A4A)
        descLabel.font = UIFontMake(14)
        return descLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(27)
            make.centerX.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.height.equalTo(187)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
