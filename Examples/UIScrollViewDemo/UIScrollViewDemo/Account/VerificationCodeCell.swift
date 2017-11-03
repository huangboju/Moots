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
        if hadGetCode {
            return
        }
        waitingCode(button: sender)
        hadGetCode = true
    }

    deinit {
        deinitTimer()
    }
}
