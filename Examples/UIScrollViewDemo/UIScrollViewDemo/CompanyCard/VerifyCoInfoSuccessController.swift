//
//  VerifyInterests.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class VerifyCoInfoSuccessController: GroupTableController {
    override func initSubviews() {
        let headerView = VerifyInterestsHeaderView()
        tableView.tableHeaderView = headerView

        let footerView = HZUIHelper.generateFooterButton(with: "完成", target: self, action: #selector(doneAction))

        tableView.tableFooterView = footerView
    }

    @objc
    private func doneAction() {
        
    }
}

class VerifyInterestsHeaderView: UIView {
    private lazy var iconTextView: IconTextView = {
        let iconTextView = IconTextView()
        iconTextView.text = "邮件已发送"
        iconTextView.image = UIImage(named: "ic_email_sent")
        iconTextView.textFont = UIFontMake(18)
        iconTextView.textColor = UIColor(hex: 0x333333)
        return iconTextView
    }()

    private lazy var tipLabel: UILabel = {
        let tipLabel = UILabel()
        tipLabel.font = UIFontMake(14)
        tipLabel.textColor = UIColor(hex: 0x333333)
        tipLabel.text = "请至邮箱关注验证邮件，并点击激活"
        return tipLabel
    }()

    private lazy var button: UIButton = {
        let button = HZUIHelper.generateNormalButton(title: "未收到验证邮件？", target: self, action: #selector(buttonAction))
        button.setTitleColor(UIColor(hex: 0x753F81), for: .normal)
        button.titleLabel?.font = UIFontMake(13)
        return button
    }()

    override init(frame: CGRect) {
        let size = CGSize(width: SCREEN_WIDTH, height: 225)
        super.init(frame: size.rect)

        let plateLayer = CALayer(frame: CGSize(width: size.width, height: size.height - 25).rect)
        plateLayer.backgroundColor = UIColor.white.cgColor
        layer.addSublayer(plateLayer)

        addSubview(iconTextView)
        iconTextView.snp.makeConstraints { (make) in
            make.top.equalTo(34)
            make.centerX.equalToSuperview()
        }
        
        addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconTextView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }

        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }

    @objc
    private func buttonAction() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CALayer {
    convenience init(frame: CGRect) {
        self.init()
        self.frame = frame
    }
}
