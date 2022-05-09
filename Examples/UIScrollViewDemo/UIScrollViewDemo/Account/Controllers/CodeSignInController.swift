//
//  SignInController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class CodeSignInController: GroupTableController, SignActionPresenter {
    override func initSubviews() {

        tableView.backgroundColor = .white
        tableView.separatorStyle = .none

        let headerView = AccountHeaderView()
        tableView.tableHeaderView = headerView

        let footerView = CodeSignInFooterView()
        tableView.tableFooterView = footerView

        rows = [
            [
                Row<AccountCell>(viewData: NoneItem()),
                Row<VerificationCodeCell>(viewData: NoneItem()),
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

