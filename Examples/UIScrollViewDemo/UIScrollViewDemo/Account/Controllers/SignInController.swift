//
//  SignInController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

@objc
protocol SignActionPresenter: class {
    
    func signInAction()
}

class SignInController: GroupTableController, SignActionPresenter {
    override func initSubviews() {

        tableView.backgroundColor = .white
        tableView.separatorStyle = .none

        let headerView = AccountHeaderView()
        tableView.tableHeaderView = headerView

        let footerView = PasswordSignInFooterView()
        tableView.tableFooterView = footerView

//        HZUIHelper.renderTranslucentNav(in: self)

        rows = [
            [
                Row<AccountCell>(viewData: NoneItem()),
                Row<PasswordCell>(viewData: NoneItem()),
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
