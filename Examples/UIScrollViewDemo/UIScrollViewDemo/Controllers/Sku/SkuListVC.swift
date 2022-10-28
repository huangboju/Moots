//
//  SkuVC.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/10/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

final class SkuListVC: GroupTableController {

    override func initSubviews() {
        rows = [
            [
                Row<TitleCell>(viewData: TitleCellItem(title: "普通解法", segue: .segue(SkuVC.self))),
                Row<TitleCell>(viewData: TitleCellItem(title: "图解法", segue: .segue(SkuVC.self)))
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
