//
//  MyCoInfoCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MyCoInfoCell: UITableViewCell, Updatable {
    
    private lazy var doubleLabel: DoubleLabel = {
        let doubleLabel = DoubleLabel()
        doubleLabel.topTextColor = UIColor(hex: 0x4A4A4A)
        doubleLabel.bottomTextColor = UIColor(hex: 0x4A4A4A)
        
        doubleLabel.topFont = UIFontMake(16)
        doubleLabel.bottomFont = UIFontMake(13)
        return doubleLabel
    }()

    private lazy var badgeLabel: UILabel = {
        let badgeLabel = UILabel()
        badgeLabel.font = UIFontMake(9)
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = UIColor(hex: 0xDD9828)
        return badgeLabel
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let dummyView = UIView()
        contentView.addSubview(dummyView)
        dummyView.snp.makeConstraints { (make) in
            make.height.equalTo(92).priority(.high)
            make.edges.equalToSuperview()
        }

        HZUIHelper.generateBottomLine(in: contentView)

        let iconView = UIImageView(image: UIImage(named: "ic_company_info"))
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.leading.equalTo(PADDING)
            make.top.equalTo(20)
        }

        contentView.addSubview(doubleLabel)
        doubleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(8)
        }

        contentView.addSubview(badgeLabel)
        badgeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.leading.equalTo(doubleLabel.snp.trailing).offset(8)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        let editButton = HZUIHelper.generateNormalButton(title: "解绑", target: self, action: #selector(editBtnAction))
        editButton.setTitleColor(UIColor(hex: 0x763E82), for: .normal)
        editButton.setTitleColor(UIColor(white: 0.9, alpha: 1), for: .highlighted)
        editButton.titleLabel?.font = UIFontMake(14)
        contentView.addSubview(editButton)
        editButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-PADDING)
            make.top.equalTo(iconView)
        }
    }

    func update(viewData: NoneItem) {
        doubleLabel.topText = "华为信息技术有限公司"
        doubleLabel.bottomText = "s****@huaiwei.com"
    }

    @objc
    private func editBtnAction() {
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
