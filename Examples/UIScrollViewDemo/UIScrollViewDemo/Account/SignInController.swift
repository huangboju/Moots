//
//  SignInController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit



extension UITableView {
    
    /** Resize a tableView header to according to the auto layout of its contents.
     - This method can resize a headerView according to changes in a dynamically set text label. Simply place this method inside viewDidLayoutSubviews.
     - To animate constrainsts, wrap a tableview.beginUpdates and .endUpdates, followed by a UIView.animateWithDuration block around constraint changes.
     */
    func sizeHeaderToFit() {
        guard let headerView = tableHeaderView else {
            return
        }
        let oldHeight = headerView.frame.height

        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height

        headerView.frame.size.height = height
        contentSize.height += (height - oldHeight)
        headerView.layoutIfNeeded()
        
    }

    func sizeFooterToFit() {
        guard let footerView = tableFooterView else {
            return
        }
        let oldHeight = footerView.frame.height
        let height = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height

        footerView.frame.size.height = height
        contentSize.height += (height - oldHeight)
        footerView.layoutIfNeeded()
    }
}

class SignInController: GroupTableController {
    override func initSubviews() {

        tableView.backgroundColor = .white

        let headerView = AccountHeaderView()
        tableView.tableHeaderView = headerView

        let footerView = AccountFooterView()
        tableView.tableFooterView = footerView

        tableView.separatorStyle = .none

        items = [
            [
                Row<AccountCell>(viewData: TmpItem()),
                Row<PasswordCell>(viewData: TmpItem()),
                Row<VerificationCodeCell>(viewData: TmpItem())
            ]
        ]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeFooterToFit()
    }
}
