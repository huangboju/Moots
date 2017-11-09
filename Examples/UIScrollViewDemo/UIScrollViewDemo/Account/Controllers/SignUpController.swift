//
//  SignUpController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/6.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class SignUpController: GroupTableController, SignActionPresenter {
    override func initSubviews() {

        tableView.backgroundColor = .white

        let headerView = AccountHeaderView()
        tableView.tableHeaderView = headerView
        
        let footerView = PasswordSignInFooterView()
        tableView.tableFooterView = footerView

        tableView.separatorStyle = .none

        rows = [
            [
                Row<AccountCell>(viewData: NoneItem()),
                Row<VerificationCodeCell>(viewData: NoneItem()),
                Row<AdjustedPasswordCell>(viewData: NoneItem())
            ]
        ]
    }

    @objc
    func signInAction() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeFooterToFit()
    }
}
