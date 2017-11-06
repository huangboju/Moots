//
//  PasswordSignInFooterView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class PasswordSignInFooterView: AccountFooterView {
    override func creatGroupButtonView() -> GroupButtonView? {
        return GroupButtonView(target: self, items: (
            ("验证码登录", #selector(codeSignInAction)),
            ("快速注册", #selector(signUpAction))
        ))
    }

    @objc
    private func codeSignInAction() {
        
    }

    @objc
    private func signUpAction() {
        
    }
}
