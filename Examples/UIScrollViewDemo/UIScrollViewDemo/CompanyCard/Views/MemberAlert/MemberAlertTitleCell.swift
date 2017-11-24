//
//  MemberAlertTitleCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/13.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MemberAlertTitleCell: UITableViewCell, Updatable {
    private lazy var doubleLabel: DoubleLabel = {
        let doubleLabel = DoubleLabel()
        doubleLabel.topTextColor = UIColor(hex: 0x4A90E2)
        doubleLabel.bottomTextColor = UIColor(hex: 0x4A4A4A)
        doubleLabel.topFont = UIFontBoldMake(20)
        doubleLabel.bottomFont = UIFontMake(14)
        
        doubleLabel.topText = "恭喜您！升级为铂金会员"
        doubleLabel.bottomText = "您的个人会员等级已随企业会员等级提升"
        
        return doubleLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let dummyView = UIView()
        contentView.addSubview(dummyView)
        dummyView.snp.makeConstraints { (make) in
            make.height.equalTo(91)
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(doubleLabel)
        doubleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
