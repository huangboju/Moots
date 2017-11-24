//
//  CoRightsFrameView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/13.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class CoRightsFrameView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFontBoldMake(16)
        titleLabel.textColor = UIColor(hex: 0x4A4A4A)
        titleLabel.text = "华为信息技术有限公司"
        return titleLabel
    }()
    
    private lazy var memberBadge: MemberBadge = {
        let memberBadge = MemberBadge()
        memberBadge.memberLevel = MemberLevel(rawValue: "金会员") ?? .star
        return memberBadge
    }()
    
    private lazy var girdView: GirdView<CoRightsGirdViewCell> = {
        let girdView = GirdView<CoRightsGirdViewCell>(items: GirdRightsItem.memberItems)
        return girdView
    }()
    
    private lazy var hLine: UIView = {
        let hLine = UIView()
        hLine.backgroundColor = UIColor(hex: 0xE2CCA1)
        return hLine
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(hex: 0xDBEDFF).cgColor
        
        addSubview(titleLabel)
        
        addSubview(hLine)
        
        addSubview(memberBadge)
        
        addSubview(girdView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.centerX.equalToSuperview()
        }
        
        hLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.centerY.equalTo(memberBadge)
            make.leading.equalTo(25)
            make.centerX.equalToSuperview()
        }
        
        memberBadge.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        girdView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
            make.top.equalTo(memberBadge.snp.bottom).offset(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
