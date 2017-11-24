//
//  ResetPasswordController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

@objc
protocol ResetPasswordNormalUIPresenter {
    func footerButtonAction()
}

extension ResetPasswordNormalUIPresenter where Self: GroupTableController {
    func creatDefaultUI(with buttonTitle: String)  {
        tableView.tableHeaderView = UIView(frame: CGSize(width: 0, height: 10).rect)
        tableView.separatorStyle = .none
        
        let footerView = UIView(frame: CGSize(width: SCREEN_WIDTH, height: 99).rect)
        let submitButton = HZUIHelper.generateDarkButton(with: buttonTitle, target: self, action: #selector(ResetPasswordNormalUIPresenter.footerButtonAction))
        submitButton.frame.origin.y = 50
        footerView.addSubview(submitButton)
        tableView.tableFooterView = footerView
    }
}

class ResetPasswordController: GroupTableController {

    override func initSubviews() {
        
        title = "重新设置登录密码"

        creatDefaultUI(with: "确定")

        rows = [
            [
                Row<ResetPasswrodCell>(viewData: NoneItem()),
                Row<CaptchaCell>(viewData: NoneItem())
            ]
        ]

        
    }

    
    // MARK: - ResetPasswordNormalUIPresenter
    @objc
    func footerButtonAction() {
        
    }
}

extension ResetPasswordController: ResetPasswordNormalUIPresenter {}
