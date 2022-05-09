//
//  MyCoRightsRecommendTitleCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MyCoRightsRecommendTitleCell: UITableViewCell, Updatable {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .yellow
        textLabel?.text = "为您推荐"
        textLabel?.font = UIFontBoldMake(16)
        textLabel?.textColor = UIColor(hex: 0x333333)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame.origin.x = 19
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
