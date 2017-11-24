//
//  ResetPasswrodCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class ResetPasswrodCell: ResetPasswordFieldCell, Updatable {
    
    override func initSubviews() {
        icon = UIImage(named: "ic_field_password")
        placeholder = "请设置6-20位数字和字母的登录密码"

        let rightView = UIButton()
        rightView.titleLabel?.font = UIFontMake(13)
        rightView.setImage(UIImage(named: "ic_btn_normal_eye"), for: .normal)
        rightView.setImage(UIImage(named: "ic_btn_selected_eye"), for: .selected)
        rightView.frame.size = rightView.intrinsicContentSize
        rightView.addTarget(self, action: #selector(rightViewAction), for: .touchUpInside)

        textField.isSecureTextEntry = true
        textField.adjustsFontSizeToFitWidth = true

        setRightView(with: rightView)
    }

    @objc
    private func rightViewAction(_ sender: UIButton) {
        textField.isSecureTextEntry = sender.isSelected

        sender.isSelected = !sender.isSelected
    }

    func update(viewData: NoneItem) {
        
    }
}
