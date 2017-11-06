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

            }.action("继续短信验证") { (_) in

            }.action("关闭")

            let image = UIImage(named: "ic_alert_attachment")
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRect(origin: .zero, size: image!.size)
    
            let headerView = UIView()
            headerView.layer.cornerRadius = 10
            headerView.backgroundColor = .red
            alert?.view.addSubview(headerView)
            headerView.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(70)
            })

            alert?.actions.forEach { $0.setValue(UIColor(hex: 0x7E3886), forKey: "titleTextColor") }

            let alertControllerTitleStr = NSMutableAttributedString(string: "华住会官网语音验证")
            alertControllerTitleStr.insert(NSAttributedString(attachment: attachment), at: 0)
//            alert?.setValue(alertControllerTitleStr, forKey: "attributedTitle")
            
            return
        }
        waitingCode(button: sender)
        hadGetCode = true
    }

    deinit {
        deinitTimer()
    }
}
