//
//  MemberComponentBtnCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/13.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

struct MemberComponentBtnItem {
    let isShowDescLabel: Bool
    let buttonTitle: String
    let buttonTarget: Any?
    let buttonAction: Selector
}

class MemberComponentBtnCell: UITableViewCell, Updatable {
    private lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor(hex: 0x4A4A4A)
        descLabel.font = UIFontMake(12)
        descLabel.textAlignment = .center
        descLabel.text = "验证企业邮箱可享受同等权益"
        descLabel.isHidden = true
        return descLabel
    }()

    private lazy var button: UIButton = {
        let inviteButton = UIButton()
        inviteButton.titleLabel?.font = UIFontBoldMake(16)
        inviteButton.setTitleColor(.white, for: .normal)
        inviteButton.setTitleColor(.lightGray, for: .highlighted)
        inviteButton.backgroundColor = UIColor(hex: 0x3C97FF)
        inviteButton.layer.cornerRadius = 18
        return inviteButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let dummyView = UIView()
        contentView.addSubview(dummyView)
        dummyView.snp.makeConstraints { (make) in
            make.height.equalTo(116)
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalToSuperview()
        }

        contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.leading.equalTo(41)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-30)
            make.height.equalTo(36)
        }
    }

    func update(viewData: MemberComponentBtnItem) {
        
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        let target = rootViewController?.visibleViewControllerIfExist

        button.setTitle(viewData.buttonTitle, for: .normal)
        button.addTarget(target, action: viewData.buttonAction, for: .touchUpInside)
        descLabel.isHidden = !viewData.isShowDescLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
