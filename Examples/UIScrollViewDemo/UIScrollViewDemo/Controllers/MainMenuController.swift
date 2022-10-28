//
//  AutoLayoutMainController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class AutoLayoutBaseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initSubviews()
    }

    func initSubviews() {}
}

class AutoLayoutMainCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset = .zero
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
    }
}

class MainMenuController: GroupTableController {

    override func initSubviews() {
        title = "\(classForCoder)"

        var result: [[RowType]] = []

        for section in data {
            let rows = section.map { Row<TitleCell>(viewData: TitleCellItem(segue: .segue($0))) }
            result.append(rows)
        }

        rows = result
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: TitleCellItem = rows[indexPath.section][indexPath.row].cellItem()
        show(item.segue) { vc in
            vc.title = item.title
        }
    }
    
    lazy var data: [[UIViewController.Type]] = [
        [
            AutoLayoutController.self,
            CollectionViewSelfSizing.self,
            TableViewSelfsizing.self,
            LayoutTrasition.self,
            ExpandingCollectionViewController.self,
            TableViewFooterSelfSizing.self,
            HiddenLayoutTestController.self,
            TableNestCollectionController.self,
            TagsController.self,
            TextViewSelfsizingController.self,
            AlignmentRectController.self
        ],
        [
            AutolayoutMenuController.self
        ],
        [
            TransitionMenuController.self
        ],
        [
            LazySequenceVC.self
        ],
        [
            NestedScrollViewVC.self
        ],
        [
            EmbedScrollViewVC.self
        ],
        [
            SkuListVC.self
        ]
    ]
}
