//
//  TableViewSectionItemsFactory.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 05/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class TableViewSectionItemsFactory {
    
    static func sectionItems(for tableView: UITableView) -> [TableViewSectionItem] {
        return [
            adjustmentBehaviorSectionItem(for: tableView),
            insetsContentViewsToSafeAreaSectionItem(for: tableView),
            customCellsSectionItem(for: tableView)
        ]
    }
    
    private static func adjustmentBehaviorSectionItem(for tableView: UITableView) -> TableViewSectionItem {
        
        
        let sectionItem = TableViewSectionItem()
        sectionItem.title = "Content Insets Adjustments Behavior"
        sectionItem.cellItems = [
            TableViewCellItem(title: ScrollViewContentInsetAdjustmentBehaviorItem.automatic.rawValue, selectionHandler: {
                if #available(iOS 11, *) {
                    tableView.contentInsetAdjustmentBehavior = .automatic
                }
            }),
            TableViewCellItem(title: ScrollViewContentInsetAdjustmentBehaviorItem.scrollableAxes.rawValue, selectionHandler: {
                if #available(iOS 11, *) {
                    tableView.contentInsetAdjustmentBehavior = .scrollableAxes
                }
            }),
            TableViewCellItem(title: ScrollViewContentInsetAdjustmentBehaviorItem.never.rawValue, selectionHandler: {
                if #available(iOS 11, *) {
                    tableView.contentInsetAdjustmentBehavior = .never
                }
            }),
            TableViewCellItem(title: ScrollViewContentInsetAdjustmentBehaviorItem.always.rawValue, selectionHandler: {
                if #available(iOS 11, *) {
                    tableView.contentInsetAdjustmentBehavior = .always
                }
            })
        ]
        if #available(iOS 11, *) {
            sectionItem.cellItems.enumerated().forEach { (offset, cellItem) in
                cellItem.enabled = offset == tableView.contentInsetAdjustmentBehavior.rawValue
            }
        }
        return sectionItem
    }

    private static func insetsContentViewsToSafeAreaSectionItem(for tableView: UITableView) -> TableViewSectionItem {
        let sectionItem = TableViewSectionItem()
        sectionItem.title = "Insets Content Views To Safe Area"
        sectionItem.cellItems = [
            TableViewCellItem(title: "enabled", switchable: true, selectionHandler: {
                if #available(iOS 11, *) {
                    tableView.insetsContentViewsToSafeArea = !tableView.insetsContentViewsToSafeArea
                }
            })
        ]
        if #available(iOS 11, *) {
            sectionItem.cellItems.forEach { cellItem in
                cellItem.enabled = tableView.insetsContentViewsToSafeArea
            }
        }
        return sectionItem
    }
    
    private static func customCellsSectionItem(for tableView: UITableView) -> TableViewSectionItem {
        let sectionItem = TableViewSectionItem()
        sectionItem.title = "Custom Cells"
        sectionItem.cellItems = Array(1..<20).map { index -> TableViewCellItem in
            return TableViewCellItem(title: "Custom cell", custom: true, switchable: true)
        }
        return sectionItem
    }
}
