//
//  VisionMenuVC.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2022/6/4.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

class VisionMenuVC: GroupTableController {

    override func initSubviews() {
        title = "\(classForCoder)"

        rows = [
            [
                Row<TitleCell>(viewData: TitleCellItem(segue: .modal(BarcodesVisionVC.self))),
                Row<TitleCell>(viewData: TitleCellItem(segue: .modal(FaceMaskViewController.self))),
                Row<TitleCell>(viewData: TitleCellItem(segue: .modal(FaceTrackVC.self)))
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
