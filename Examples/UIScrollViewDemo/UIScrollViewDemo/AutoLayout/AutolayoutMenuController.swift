//
//  AutolayoutMenuController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/12.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class AutolayoutMenuController: GroupTableController {

    lazy var data: [[UIViewController.Type]] = [
        [
            SimpleStackViewController.self,
            NestedStackViewController.self,
            DynamicStackViewController.self,
            TwoEqualWidthViewsController.self,
            TwoDifferentWidthViews.self,
            TwoViewsWithComplexWidths.self,
            SimpleLabelAndTextField.self,
            DynamicHeightLabelAndTextField.self,
            FixedHeightColumns.self,
            DynamicHeightColumns.self,
            TwoEqualWidthButtons.self,
            ThreeEqualWidthButtons.self,
            EqualWhiteSpace.self,
            ButtonsSizeClass.self,
            GroupingViews.self,
            ImageViewsAndAspectFitMode.self,
            AspectRatioImageView.self,
            DynamicTextAndReadability.self,
            WorkingWithScrollViews.self,
            AnimatingChangesViewController.self,
            SizeClassSpecificLayouts.self,
            UIKitDynamicsViewController.self,
        ]
    ]
    
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
}
