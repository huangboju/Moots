//
//  VerifyCoInfoController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

struct CurrRightModel {
    let sequence: Int
    let rightsName: String
    let rightsDesc: String
}

struct CoInfoModel {
    let companyName: String
    let basicLevel: String
    let companyMemberID: String
    let comPanyMailboxSuffix: String
}

//struct CompanyCardModel {
//    let companyInfo: CoInfoModel
//    let
//}

class VerifyCoInfoController: GroupTableController {
    override func initSubviews() {
        tableView.tableHeaderView = VerifyCoInfoHeaderView(state: .canBebound)
        tableView.separatorStyle = .none

        rows = [
            [
                Row<CompanyInfoCell>(viewData: NoneItem()),
                Row<VerifyCoInfoFieldCell>(viewData: VerifyCoInfoFieldItem(placeholder: "请输入您的企业邮箱", title: "工作邮箱")),
                Row<VerifyCoInfoFieldCell>(viewData: VerifyCoInfoFieldItem(placeholder: "请输入公司名称", title: "公司名称")),
                Row<CoInfoVerifyCell>(viewData: NoneItem())
            ]
        ]
    }

    @objc
    func verifyAction() {
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let headerView: VerifyCoInfoHeaderView? = tableHeaderView()
        headerView?.model = "华住金会员权益"
    }
}

