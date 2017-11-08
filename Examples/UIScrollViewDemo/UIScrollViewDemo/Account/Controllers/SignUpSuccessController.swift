//
//  SignUpSuccessController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class SignUpSuccessController: GroupTableController {
    override func initSubviews() {
        tableView.tableHeaderView = SignUpSuccessHeaderView()
        
        
        let footerView = HZUIHelper.generateFooterButton(with: "立即开启华住会", target: self, action: #selector(startHZClub))
        tableView.tableFooterView = footerView
    }
    
    @objc
    private func startHZClub() {
        
    }
}
