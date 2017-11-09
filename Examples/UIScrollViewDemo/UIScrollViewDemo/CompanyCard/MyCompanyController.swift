//
//  MyCompanyController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MyCompanyController: UIViewController {
    
    static let formViewHeight: CGFloat = 434
    
    private lazy var formView: FormView = {
        let formView = FormView()
        let headerView = MyCompanyFormHeaderView(frame: CGSize(width: SCREEN_WIDTH, height: 0.1).rect)
        formView.tableHeaderView = headerView
        headerView.alpha = 0
        formView.separatorStyle = .none
        formView.isScrollEnabled = false
        formView.backgroundColor = .white

        formView.rows = [
            [
                Row<MyCoInfoCell>(viewData: NoneItem()),
                Row<MyCoRightsCell>(viewData: NoneItem()),
                Row<MyCoRightsActiveCell>(viewData: NoneItem()),
                Row<MyCoRightsRecommendTitleCell>(viewData: NoneItem())
            ]
        ]

        return formView
    }()

    private let myCoRightsRecommendView = MyCoRightsRecommendView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        myCoRightsRecommendView.addHeaderView(formView)

        let items = (0...4).map { $0.description }
        myCoRightsRecommendView.data = items

        view.addSubview(myCoRightsRecommendView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(test))
    }

    @objc
    func test() {
        formView.beginUpdates()
        UIView.animate(withDuration: 0.1) {
            self.formView.tableHeaderView?.alpha = 1
            self.formView.tableHeaderView?.frame.size.height = 63
        }
        formView.endUpdates()

        formView.frame.size.height += 63
        myCoRightsRecommendView.freshView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        formView.frame = CGSize(width: view.bounds.width, height: type(of: self).formViewHeight).rect
        myCoRightsRecommendView.frame = view.bounds
    }
}
