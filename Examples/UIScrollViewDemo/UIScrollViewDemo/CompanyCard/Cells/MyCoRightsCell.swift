//
//  MyCoRightsCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

struct GirdRightsItem {
    let imageName: String
    let title: String
    let selectorName: String
    
    private static let imageNames = [
        "discount",
        "integral",
        "breakfast",
        "checkout"
    ]
    
    private static let coTitles = [
        "8.8折优惠",
        "2倍积分",
        "1份早餐",
        "14:00退房",
    ]
    
    private static let memberTitles = [
        "房费8.8折",
        "免费早餐",
        "2倍积分",
    ]

    static var coItems: [GirdRightsItem] {
        return zip(imageNames, coTitles).map {
            GirdRightsItem(imageName: "ic_my_co_rights_\($0.0)", title: $0.1, selectorName: "coRightsStyle")
        }
    }

    static var memberItems: [GirdRightsItem] {
        return zip(imageNames, memberTitles).map {
            GirdRightsItem(imageName: "ic_my_co_rights_\($0.0)", title: $0.1, selectorName: "memberRightsStyle")
        }
    }
}

class MyCoRightsCell: UITableViewCell, Updatable {
    
    private lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor(hex: 0x4A4A4A)
        descLabel.font = UIFontMake(14)
        descLabel.text = "华住金会员权益"
        return descLabel
    }()

    private lazy var girdView: GirdView<CoRightsGirdViewCell> = {
        let girdView = GirdView<CoRightsGirdViewCell>(items: GirdRightsItem.coItems)
        return girdView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let dummyView = UIView()
        contentView.addSubview(dummyView)
        dummyView.snp.makeConstraints { (make) in
            make.height.equalTo(187).priority(.high)
            make.edges.equalToSuperview()
        }

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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
