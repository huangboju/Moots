//
//  MyCompanyFormHeaderView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MyCompanyFormHeaderView: UIView {
    
    private lazy var doubleLabel: DoubleLabel = {
        let doubleLabel = DoubleLabel()
        doubleLabel.topTextColor = UIColor(hex: 0x7A471A)
        doubleLabel.bottomTextColor = UIColor(hex: 0x7A471A)
        doubleLabel.topFont = UIFontMake(14)
        doubleLabel.bottomFont = UIFontMake(12)
        doubleLabel.topText = "公司信息已过期需重新验证您的企业邮箱"
        doubleLabel.bottomText = "上次激活时间：2016年12月12日"
        doubleLabel.textAlignment = .left
        return doubleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0xE7D4AF)

        addSubview(doubleLabel)
        doubleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(PADDING)
            make.centerY.equalToSuperview()
        }
        
        let sendEmailBtn = HZUIHelper.generateNormalButton(title: "发送邮件", target: viewController(), action: #selector(sendEmailAction))
        sendEmailBtn.titleLabel?.font = UIFontMake(14)
        sendEmailBtn.setTitleColor(UIColor(hex: 0x333333), for: .normal)
        sendEmailBtn.setTitleColor(.lightGray, for: .highlighted)
        sendEmailBtn.layer.cornerRadius = 3
        sendEmailBtn.layer.borderWidth = 1
        sendEmailBtn.backgroundColor = .white
        sendEmailBtn.layer.borderColor = UIColor(hex: 0xD7B884).cgColor
        addSubview(sendEmailBtn)
        sendEmailBtn.snp.makeConstraints { (make) in
            make.width.equalTo(78)
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-PADDING)
        }
    }

    @objc
    private func sendEmailAction() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
