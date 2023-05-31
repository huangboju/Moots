//
//  DiffableDatasourceMenuVC.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2022/6/19.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

class DiffableDatasourceMenuVC: GroupTableController {

    override func initSubviews() {
        rows = [
            [
                Row<TitleCell>(viewData: TitleCellItem(segue: .push(TableDiffableVC.self)))
            ]
        ]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: TitleCellItem = rows[indexPath.section][indexPath.row].cellItem()
        show(item.segue) { vc in
            vc.title = item.title
        }
    }
}
