//
//  AccountFooterView.swift
//  HtinnsFlat
//
//  Created by 黄伯驹 on 2017/11/2.
//  Copyright © 2017年 hangting. All rights reserved.
//

import UIKit

class AccountFooterView: UIView {
    
    private(set) var button: UIButton!

    private lazy var tipLabel: NELineLabel = {
        let tipLabel = NELineLabel()
        tipLabel.text = "或从以下方式登录"
        tipLabel.textAlignment = .center
        tipLabel.font = UIFontMake(13)
        tipLabel.textColor = UIColor(hex: 0x9B9B9B)
        tipLabel.lineColor = UIColor(hex: 0xF1F1F1)
        return tipLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 300))

        button = HZUIHelper.generateNormalButton(target: self, action: #selector(buttonAction))
        button.backgroundColor = UIColor(hex: 0xA356AB)
//        button.highlightedBackgroundColor = button.backgroundColor?.qmui_transition(to: UIColor(white: 0.3, alpha: 0.3), progress: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFontMake(14)
        addSubview(button)

        button.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.trailing.equalTo(-16).priority(.high)
            make.leading.equalTo(16)
            make.top.equalToSuperview().offset(5)
        }

        addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(button.snp.bottom).offset(170)
            make.width.equalTo(230)
            make.centerX.equalTo(snp.centerX)
        }
        
        generatOtherSocialView()
    }
    
    func generatOtherSocialView() {
        let containerView = UIView()
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.leading.equalTo(68)
            make.trailing.equalTo(-68).priority(.high)
            make.bottom.equalToSuperview().offset(-58)
            make.top.equalTo(tipLabel.snp.bottom).offset(19)
        }


        let names = [
            "wechat",
            "weibo",
            "qq",
            "alipay"
        ]
        
        var tmpDummyView: UIView?
        var tmpBtn: UIButton?

        for (i, name) in names.enumerated() {
            let button = HZUIHelper.generateNormalButton(with: "ic_btn_\(name)", target: self, action: Selector("\(name)Action"))
            containerView.addSubview(button)

            let dummyView = UIView()
            containerView.addSubview(dummyView)

            if let tmpDummyView = tmpDummyView, let tmpBtn = tmpBtn {
                button.snp.makeConstraints({ (make) in
                    make.size.top.equalTo(tmpBtn)
                    make.leading.equalTo(tmpDummyView.snp.trailing)
                })
                dummyView.snp.makeConstraints({ (make) in
                    make.width.equalTo(tmpDummyView)
                    make.leading.equalTo(button.snp.trailing)
                    if i == names.count - 1 {
                        // 最后一个
                        make.trailing.equalToSuperview()
                    }
                })
            } else {
                // 第一次
                button.snp.makeConstraints({ (make) in
                    make.top.bottom.leading.equalToSuperview()
                })
                dummyView.snp.makeConstraints({ (make) in
                    make.leading.equalTo(button.snp.trailing)
                })
            }

            tmpDummyView = dummyView
            tmpBtn = button
        }
    }
    
    
    // MARK: - Actions
    @objc private func wechatAction() {

    }

    @objc private func weiboAction() {
        
    }
    
    @objc private func qqAction() {
        
    }
    
    @objc private func alipayAction() {
    
    }

     @objc open func buttonAction() {}

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
