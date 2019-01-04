//
//  SectionManager.swift
//  TableExample
//
//  Created by Malte Schonvogel on 07.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

protocol CollectionViewCell {

    associatedtype CellContent

    var content: CellContent? { get set }
    static func calculateHeight(content: CellContent, forWidth width: CGFloat) -> CGFloat
}


extension UICollectionViewCell {

    static var identifier: String {
        return String(describing: self)
    }
}


protocol ManageableSection: SectionRepresentable, CellRepresentable {
}


protocol SectionManager: ManageableSection {
    
    associatedtype ItemType: CellRepresentable

    var items: [ItemType] { get set }
}


extension SectionManager {

    var numberOfItems: Int {

        return items.count
    }

    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {

        return items[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }

    func itemHeight(forWidth width: CGFloat, indexPath: IndexPath) -> CGFloat {

        return items[indexPath.item].itemHeight(forWidth: width, indexPath: indexPath)
    }

    func headerHeight(forWidth width: CGFloat) -> CGFloat {

        return SectionHeaderView.calculateHeight(title: title, forWidth: width)
    }

    func headerInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.viewReuseIdentifer, for: indexPath) as! SectionHeaderView
        header.title = title

        return header
    }
}
