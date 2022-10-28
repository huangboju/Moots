//
//  VariantFlowLayout.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/10/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

class VariantFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesCopy: [UICollectionViewLayoutAttributes] = []
        if let attributes = super.layoutAttributesForElements(in: rect) {
            for attribute in attributes {
                if let a = attribute.copy() as? UICollectionViewLayoutAttributes {
                    attributesCopy.append(a)
                }
            }
        }
        for attributes in attributesCopy where attributes.representedElementKind == nil {
            let indexpath = attributes.indexPath
            if let attr = layoutAttributesForItem(at: indexpath) {
                attributes.frame = attr.frame
            }
        }
        return attributesCopy
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let currentItemAttributes = super.layoutAttributesForItem(at: indexPath as IndexPath)?.copy() as? UICollectionViewLayoutAttributes, let collection = collectionView {
            let sectionInset = evaluatedSectionInsetForItem(at: indexPath.section)
            let isFirstItemInSection = indexPath.item == 0
            let layoutWidth = collection.frame.width - sectionInset.left - sectionInset.right
            guard !isFirstItemInSection else {
                currentItemAttributes.leftAlignFrame(with: sectionInset)
                return currentItemAttributes
            }
            let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
            let previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame ?? CGRect.zero
            let previousFrameRightPoint = previousFrame.origin.x + previousFrame.width
            let currentFrame = currentItemAttributes.frame
            let strecthedCurrentFrame = CGRect(x: sectionInset.left, y: currentFrame.origin.y, width: layoutWidth, height: currentFrame.size.height)
            let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
            guard !isFirstItemInRow else {
                currentItemAttributes.leftAlignFrame(with: sectionInset)
                return currentItemAttributes
            }

            var frame = currentItemAttributes.frame
            frame.origin.x = previousFrameRightPoint + evaluatedMinimumInteritemSpacing(at: indexPath.section)
            currentItemAttributes.frame = frame
            return currentItemAttributes

        }
        return nil
    }
}

private extension VariantFlowLayout {
    func evaluatedMinimumInteritemSpacing(at sectionIndex: Int) -> CGFloat {
        if let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout, let collection = collectionView {
            let inteitemSpacing = delegate.collectionView?(collection, layout: self, minimumInteritemSpacingForSectionAt: sectionIndex)
            if let inteitemSpacing = inteitemSpacing {
                return inteitemSpacing
            }
        }
        return minimumInteritemSpacing
    }

    func evaluatedSectionInsetForItem(at index: Int) -> UIEdgeInsets {
        if let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout, let collection = collectionView {
            let insetForSection = delegate.collectionView?(collection, layout: self, insetForSectionAt: index)
            if let insetForSectionAt = insetForSection {
                return insetForSectionAt
            }
        }
        return sectionInset
    }
}

private extension UICollectionViewLayoutAttributes {
    func leftAlignFrame(with sectionInset: UIEdgeInsets) {
        frame.origin.x = sectionInset.left
    }
}
