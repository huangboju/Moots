//
//  JSCoreMenuVC.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2023/5/31.
//  Copyright © 2023 伯驹 黄. All rights reserved.
//

import Foundation

class JSCoreMenuVC: GroupTableController {

    override func initSubviews() {
        title = "\(classForCoder)"

        rows = [
            [
                Row<TitleCell>(viewData: TitleCellItem(segue: .push(JSCoreBasicsVC.self))),
                Row<TitleCell>(viewData: TitleCellItem(segue: .push(JSCoreMatrixVC.self))),
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
