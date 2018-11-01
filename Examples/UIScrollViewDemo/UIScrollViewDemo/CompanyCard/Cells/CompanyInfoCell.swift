//
//  CompanyInfoCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class CompanyInfoCell: UITableViewCell, Updatable {

    private lazy var iconTextView: IconTextView = {
       let iconTextView = IconTextView()
        iconTextView.text = "公司信息"
        iconTextView.image = UIImage(named: "ic_company_info")
        iconTextView.textColor = UIColor(hex: 0x4A4A4A)
        iconTextView.textFont = UIFontMake(15)
        return iconTextView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(iconTextView)
        iconTextView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(PADDING)
            make.top.equalTo(30)
        }
        
        let dummyView = UIView()
        contentView.addSubview(dummyView)
        dummyView.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
