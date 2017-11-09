//
//  MyCoRightsRecommendCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MyCoRightsRecommendCell: UITableViewCell {

    private lazy var recommendView: MyCoRightsRecommendView = {
        let recommendView = MyCoRightsRecommendView()
        return recommendView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(recommendView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
