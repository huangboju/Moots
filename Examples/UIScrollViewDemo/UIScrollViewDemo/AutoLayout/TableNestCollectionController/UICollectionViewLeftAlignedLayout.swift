//
//  UICollectionViewLeftAlignedLayout.swift
//  SwiftDemo
//
//  Created by fanpyi on 22/2/16.
//  Copyright © 2016 fanpyi. All rights reserved.
//  based on http://stackoverflow.com/questions/13017257/how-do-you-determine-spacing-between-cells-in-uicollectionview-flowlayout  https://github.com/mokagio/UICollectionViewLeftAlignedLayout

import UIKit
extension UICollectionViewLayoutAttributes {
    func leftAlignFrameWithSectionInset(_ sectionInset: UIEdgeInsets){
        frame.origin.x = sectionInset.left
    }
}

class UICollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var updatedAttributes = originalAttributes

        for attributes in updatedAttributes {
            guard attributes.representedElementKind == nil else {
                continue
            }
            guard let index = updatedAttributes.index(of: attributes) else {
                continue
            }
            if let attr = layoutAttributesForItem(at: attributes.indexPath) {
                updatedAttributes[index] = attr
            }
        }
        return updatedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        guard let currentItemAttributes = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }

        let sectionInset = evaluatedSectionInsetForItem(at: indexPath.section)
        let isFirstItemInSection = indexPath.item == 0
        let layoutWidth = collectionView!.frame.width - sectionInset.left - sectionInset.right

        if isFirstItemInSection {
            currentItemAttributes.leftAlignFrameWithSectionInset(sectionInset)
            return currentItemAttributes
        }

        let previousIndexPath = IndexPath(row: indexPath.item - 1, section: indexPath.section)
        
        let previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame ?? .zero
        let previousFrameRightPoint = previousFrame.minX + previousFrame.width
        let currentFrame = currentItemAttributes.frame
        let strecthedCurrentFrame = CGRect(x: sectionInset.left,
                                           y: currentFrame.minY,
                                           width: layoutWidth,
                                           height: currentFrame.height)
        // if the current frame, once left aligned to the left and stretched to the full collection view
        // widht intersects the previous frame then they are on the same line
        let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
        
        if isFirstItemInRow {
            // make sure the first item on a line is left aligned
            currentItemAttributes.leftAlignFrameWithSectionInset(sectionInset)
            return currentItemAttributes
        }

        currentItemAttributes.frame.origin.x = previousFrameRightPoint + evaluatedMinimumInteritemSpacing(at: indexPath.section)
        return currentItemAttributes
    }
    
    func evaluatedMinimumInteritemSpacing(at sectionIndex:Int) -> CGFloat {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            let inteitemSpacing = delegate.collectionView?(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: sectionIndex)
            if let inteitemSpacing = inteitemSpacing {
                return inteitemSpacing
            }
        }
        return minimumInteritemSpacing
        
    }

    func evaluatedSectionInsetForItem(at index: Int) -> UIEdgeInsets {
        if let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            let insetForSection = delegate.collectionView?(collectionView!, layout: self, insetForSectionAt: index)
            if let insetForSectionAt = insetForSection {
                return insetForSectionAt
            }
        }
        return sectionInset
    }
}
