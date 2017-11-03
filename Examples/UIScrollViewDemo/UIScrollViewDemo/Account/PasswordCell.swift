//
//  PasswordCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class PasswordCell: TextFiledCell {

    override func didInitialzed() {
        let rightView = UIButton()
        rightView.titleLabel?.font = UIFontMake(13)
        rightView.setTitle("忘记密码？", for: .normal)
        rightView.frame.size = rightView.intrinsicContentSize
        rightView.setTitleColor(UIColor(hex: 0x333333), for: .normal)
        rightView.setTitleColor(.lightGray, for: .highlighted)

        textField.isSecureTextEntry = true

        setField(with: ("密码", "ic_field_password"))

        setRightView(with: rightView)
    }
}
