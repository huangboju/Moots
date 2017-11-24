//
//  MemberComponentFrameCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/13.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MemberComponentFrameCell: UITableViewCell, Updatable {
    private lazy var coRightsFrameView: CoRightsFrameView = {
        let coRightsFrameView = CoRightsFrameView()
        return coRightsFrameView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let dummyView = UIView()
        contentView.addSubview(dummyView)
        dummyView.snp.makeConstraints { (make) in
            make.height.equalTo(193)
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(coRightsFrameView)
        coRightsFrameView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalToSuperview()
            make.leading.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
