//
//  SignInController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class CodeSignInController: GroupTableController {
    override func initSubviews() {

        tableView.backgroundColor = .white
        tableView.separatorStyle = .none

        let headerView = AccountHeaderView()
        tableView.tableHeaderView = headerView
        
        let footerView = CodeSignInFooterView()
        tableView.tableFooterView = footerView
        
        items = [
            [
                Row<AccountCell>(viewData: NoneItem()),
                Row<VerificationCodeCell>(viewData: NoneItem()),
            ]
        ]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeFooterToFit()
    }
}

