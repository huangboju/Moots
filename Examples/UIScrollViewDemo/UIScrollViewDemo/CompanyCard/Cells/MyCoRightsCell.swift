//
//  MyCoRightsCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MyCoRightsCell: UITableViewCell, Updatable {
    
    private lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor(hex: 0x4A4A4A)
        descLabel.font = UIFontMake(14)
        descLabel.text = "华住金会员权益"
        return descLabel
    }()
    
    private lazy var girdView: GirdView<GirdViewCell> = {
        let girdView = GirdView<GirdViewCell>(items: MyCoRightsCell.items)
        return girdView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(27)
            make.centerX.equalToSuperview()
        }

        contentView.addSubview(girdView)
        girdView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom).offset(30)
            make.bottom.equalTo(-32)
        }

        contentView.snp.makeConstraints { (make) in
            make.height.equalTo(187)
            make.leading.trailing.equalToSuperview()
        }
    }

    static var items: [GirdItem] {
        let contets = [
            ("8.8折优惠", "discount"),
            ("2倍积分", "integral"),
            ("1份早餐", "breakfast"),
            ("14:00退房", "checkout")
        ]

        return contets.map { GirdItem(imageName: "ic_my_co_rights_\($0.1)", title: $0.0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
