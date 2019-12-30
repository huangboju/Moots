//
//  CollectionViewCellItemsFactory.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 13/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class CollectionViewSectionItemsFactory {
    
    static func sectionItems(for collectionView: UICollectionView) -> [CollectionViewSectionItem] {
        return [
            insetsSectionItem(for: collectionView),
            gridSectionItem(for: collectionView),
            gridSectionItem(for: collectionView),
        ]
    }

    private static func insetsSectionItem(for collectionView: UICollectionView) -> CollectionViewSectionItem {
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let sectionItem = CollectionViewSectionItem()
        sectionItem.title = "Section Inset Reference"
        sectionItem.minimumLineSpacing = 2.0
        sectionItem.minimumInteritemSpacing = 2.0
        sectionItem.referenceHeaderSize = CGSize(width: 200.0, height: 60.0)
        sectionItem.cellItems = [
            CollectionViewCellItem(title: "FromContentInset", size: CGSize(width: 300.0, height: 50.0), selectionHandler: {
                if #available(iOS 11, *) {
                    collectionViewLayout.sectionInsetReference = .fromContentInset
                }
            }),
            CollectionViewCellItem(title: "FromSafeArea", size: CGSize(width: 300.0, height: 50.0), selectionHandler: {
                if #available(iOS 11, *) {
                    collectionViewLayout.sectionInsetReference = .fromSafeArea
                }
            }),
            CollectionViewCellItem(title: "FromLayoutMargins", size: CGSize(width: 300.0, height: 50.0), selectionHandler: {
                if #available(iOS 11, *) {
                    collectionViewLayout.sectionInsetReference = .fromLayoutMargins
                }
            }),
        ]
        if #available(iOS 11, *) {
            sectionItem.cellItems.enumerated().forEach { (offset, cellItem) in
                cellItem.enabled = offset == collectionViewLayout.sectionInsetReference.rawValue
            }
        }
        return sectionItem
    }

    private static func gridSectionItem(for collectionView: UICollectionView) -> CollectionViewSectionItem {
        let sectionItem = CollectionViewSectionItem()
        sectionItem.title = "Cells"
        sectionItem.minimumLineSpacing = 2.0
        sectionItem.minimumInteritemSpacing = 2.0
        sectionItem.referenceHeaderSize = CGSize(width: 200.0, height: 60.0)
        sectionItem.cellItems = Array(0...49).map { item -> CollectionViewCellItem in
            return CollectionViewCellItem(title: "Cell", size: CGSize(width: 50.0, height: 50.0))
        }
        return sectionItem
    }
}
