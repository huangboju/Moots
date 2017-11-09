//
//  MyCompanyController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MyCompanyController: GroupTableController {
    
    private let myCoRightsRecommendView = MyCoRightsRecommendView(frame: .zero)

    override func initSubviews() {

        tableView.tableHeaderView = UIView(frame: CGSize(width: SCREEN_WIDTH, height: 0.1).rect)
        tableView.separatorStyle = .none

        rows = [
            [
                Row<MyCoInfoCell>(viewData: NoneItem()),
                Row<MyCoRightsCell>(viewData: NoneItem()),
                Row<MyCoRightsActiveCell>(viewData: NoneItem())
            ]
        ]

        let items = (0...10).map { $0.description }
        myCoRightsRecommendView.data = items

        view.addSubview(myCoRightsRecommendView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        myCoRightsRecommendView.frame = view.bounds
    }
}
