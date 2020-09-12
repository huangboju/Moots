//
//  CollectionViewSectionItem.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 13/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class CollectionViewSectionItem {
    
    var title = ""
    var attachContentToSafeArea = false
    var referenceHeaderSize = CGSize.zero
    var insets = UIEdgeInsets.zero
    var minimumLineSpacing = CGFloat(0.0)
    var minimumInteritemSpacing = CGFloat(0.0)
    var cellItems = [CollectionViewCellItem]()
}

extension CollectionViewSectionItem: CollectionViewReusableViewDelegate {
    
    func collectionViewReusableViewSwitcherAction(_ cell: CollectionViewReusableView) {
        attachContentToSafeArea = !attachContentToSafeArea
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }
}
