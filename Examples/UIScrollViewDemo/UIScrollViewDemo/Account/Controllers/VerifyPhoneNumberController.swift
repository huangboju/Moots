//
//  VerifyPhoneNumberController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class VerifyPhoneNumberController: GroupTableController {
    
    override func initSubviews() {
        
        title = "验证手机号"
        
        creatDefaultUI(with: "确定")

        rows = [
            [
                Row<AccountCell>(viewData: NoneItem()),
                Row<VerificationCodeCell>(viewData: NoneItem())
            ]
        ]
    }
    
    
    // MARK: - ResetPasswordNormalUIPresenter
    @objc
    func footerButtonAction() {
        
    }
}

extension VerifyPhoneNumberController: ResetPasswordNormalUIPresenter {}
