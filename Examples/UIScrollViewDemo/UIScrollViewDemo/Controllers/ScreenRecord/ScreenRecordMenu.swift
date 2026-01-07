//
//  ScreenRecordMenu.swift
//  UIScrollViewDemo
//
//  Created by bula on 2026/1/7.
//  Copyright © 2026 伯驹 黄. All rights reserved.
//

import Foundation

class ScreenRecordMenu: GroupTableController {

    override func initSubviews() {
        title = "\(classForCoder)"

        rows = [
            [
                Row<TitleCell>(viewData: TitleCellItem(segue: .push(ASScreenRecorderVC.self))),
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
