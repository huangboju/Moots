//
//  VerificationCodeCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class VerificationCodeCell: TextFiledCell, VerificationCodePresenter {
    var timer: DispatchSourceTimer?
    
    private var hadGetCode = false

    override func didInitialzed() {

        let codeButton = UIButton()
        codeButton.setTitle("获取验证码", for: .normal)
        codeButton.frame.size = CGSize(width: 90, height: codeButton.intrinsicContentSize.height)
        codeButton.titleLabel?.font = UIFontMake(13)
        codeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        codeButton.contentEdgeInsets.right = (codeButton.intrinsicContentSize.width - codeButton.frame.width) / 2
        codeButton.setTitleColor(UIColor(hex: 0x753581), for: .normal)
        codeButton.setTitleColor(UIColor(hex: 0x999999), for: .disabled)
        codeButton.addTarget(self, action: #selector(requestCodeAction), for: .touchUpInside)

        let vLine = UIView()
        vLine.backgroundColor = UIColor(hex: 0xCCCCCC)
        vLine.frame = CGRect(x: 5, y: 0, width: 1, height: 16)
        vLine.center.y = codeButton.center.y
        codeButton.addSubview(vLine)

        setRightView(with: codeButton)

        setField(with: ("手机验证码", "ic_field_code"))
    }

    @objc
    private func requestCodeAction(sender: UIButton) {
        if !hadGetCode {
            
            let alert = viewController()?.showAlert(actionTitle: "立即接听语音", title: "", message: "\n\n\n使用语音验证，您将受到来自华住会官方的告知验证码的固定电话，请安心接听") { (_) in

            }.action("继续短信验证") { [weak self] (_) in
                self?.hadGetCode = false
            }.action("关闭")

            let headerView = UIView()
            alert?.view.addSubview(headerView)
            headerView.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.leading.equalTo(27)
                make.trailing.equalTo(-27)
                make.height.equalTo(70)
            })

            let imageView = UIImageView(image: UIImage(named: "ic_alert_attachment"))
            headerView.addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
                make.leading.equalToSuperview()
            })

            let titleLabel = UILabel()
            titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
            titleLabel.textColor = UIColor(hex: 0x333333)
            titleLabel.text = "华住会官网语音验证"
            headerView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints({ (make) in
                make.trailing.top.bottom.equalToSuperview()
                make.leading.equalTo(imageView.snp.trailing).offset(10)
                make.centerY.equalTo(imageView.snp.centerY)
            })
            alert?.actions.forEach { $0.setValue(UIColor(hex: 0x7E3886), forKey: "titleTextColor") }
            
            return
        }
        waitingCode(button: sender)
        hadGetCode = true
    }

    deinit {
        deinitTimer()
    }
}
