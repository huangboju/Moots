//
//  TableFlowLayout.swift
//
//  Created by Malte Schonvogel on 5/10/17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

@objc public protocol TableFlowLayoutDelegate: UICollectionViewDelegateFlowLayout {

    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberOfColumnsForSectionAtIndex section: Int) -> Int
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForRowInSectionAtIndex section: Int) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAtIndexPath indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, borderWidthForSectionAtIndex section: Int) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, borderColorForSectionAtIndex section: Int) -> UIColor
}

public class TableFlowLayout: UICollectionViewFlowLayout {

    open var numberOfCols: Int = 1
    open var rowReferenceSize: CGFloat?
    open var sectionBorderWidth: CGFloat?
    open var sectionBorderColor: UIColor?
    open var collectionViewHeaderHeight: CGFloat = 0

    private var headerAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var footerAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var cellAttributes = [IndexPath: TableCollectionViewLayoutAttributes]()

    private var contentSize = CGSize.zero

    fileprivate weak var delegate: TableFlowLayoutDelegate? {
        get {
            return collectionView?.delegate as? TableFlowLayoutDelegate
        }
    }

    override public func prepare() {

        assert(delegate != nil, "delegate must be set!")

        guard let collectionView = collectionView else {
            assertionFailure("collectionView may not be nil!")
            return
        }

        let numberOfSections = collectionView.numberOfSections
        guard numberOfSections > 0 else {
            return
        }

        // Clear cache
        headerAttributes.removeAll()
        cellAttributes.removeAll()
        footerAttributes.removeAll()
        contentSize = CGSize.zero
        contentSize.height = collectionViewHeaderHeight

        let viewWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right

        for section in 0..<numberOfSections {

            let numberOfItemsInSection = collectionView.numberOfItems(inSection: section)
            let numberOfColsInSection = numberOfColumnsInSection(section)
            let sectionInset = insetForSection(section)
            let borderWidth = borderWidthForSection(section)
            let borderColor = borderColorForSection(section)
            let minimumLineSpacing = minimumLineSpacingForSection(section)
            let minimumInteritemSpacing = minimumInteritemSpacingForSection(section)
            let headerSize = referenceSizeForHeaderInSection(section)
            let footerSize = referenceSizeForFooterInSection(section)
            let rowHeight = heightForRowInSection(section)
            let indexPath = IndexPath(item: 0, section: section)


            // HeaderSize
            let headerLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            headerLayoutAttributes.frame.origin = CGPoint(x: 0, y: contentSize.height)
            headerLayoutAttributes.frame.size = CGSize(width: viewWidth, height: headerSize.height)
            headerAttributes[indexPath] = headerLayoutAttributes


            // Items
            var sectionSize = CGSize.zero

            if numberOfItemsInSection > 0 {

                let sectionOffset = CGPoint(x: 0, y: contentSize.height + headerSize.height)
                var contentMaxValueInScrollDirection: CGFloat = sectionOffset.y

                let availableSpace = viewWidth - sectionInset.left - sectionInset.right + (borderWidth * 2)
                let itemWidth = (availableSpace + borderWidth*CGFloat(numberOfColsInSection-1) - minimumInteritemSpacing * CGFloat(numberOfColsInSection-1)) / CGFloat(numberOfColsInSection)

                let offsetX = sectionOffset.x + sectionInset.left
                var offset = CGPoint(x: offsetX, y: sectionOffset.y + sectionInset.top)

                var itemHeight: CGFloat = rowHeight ?? rowReferenceSize ?? 0

                for itemIndex in 0..<numberOfItemsInSection {

                    if (offset.x + borderWidth*2) >= availableSpace {
                        offset.x = offsetX - borderWidth
                        offset.y += itemHeight + minimumLineSpacing - borderWidth
                    } else {
                        offset.x -= borderWidth
                    }

                    // Individual Item height
                    if offset.x == (offsetX - borderWidth) && rowHeight == nil && rowReferenceSize == nil {
                        let range = itemIndex..<min(numberOfItemsInSection, itemIndex + numberOfColsInSection)

                        itemHeight = range.compactMap({
                            let indexPath = IndexPath(item: $0, section: section)
                            return heightForItemAtIndexPath(indexPath, itemWidth: itemWidth)
                        }).max() ?? 0
                    }

                    let indexPath = IndexPath(item: itemIndex, section: section)
                    let frame = CGRect(x: offset.x, y: offset.y, width: itemWidth, height: itemHeight)

                    let cellLayoutAttributes = TableCollectionViewLayoutAttributes(forCellWith: indexPath)
                    cellLayoutAttributes.frame = frame
                    cellLayoutAttributes.borderWidth = borderWidth
                    cellLayoutAttributes.borderColor = borderColor

                    cellAttributes[indexPath] = cellLayoutAttributes

                    contentMaxValueInScrollDirection = frame.maxY
                    offset.x += frame.width + minimumInteritemSpacing
                }

                sectionSize = CGSize(width: viewWidth, height: contentMaxValueInScrollDirection - sectionOffset.y + sectionInset.bottom)
            }

            // FooterSize
            let footerLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
            footerLayoutAttributes.frame.origin = CGPoint(x: 0, y: contentSize.height + headerSize.height + sectionSize.height)
            footerLayoutAttributes.frame.size = CGSize(width: viewWidth, height: footerSize.height)
            footerAttributes[indexPath] = footerLayoutAttributes

            // ContentSize
            contentSize = CGSize(width: sectionSize.width, height: contentSize.height + headerSize.height + sectionSize.height + footerSize.height)
        }
    }

    override public var collectionViewContentSize: CGSize {

        return contentSize
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var result = [UICollectionViewLayoutAttributes]()

        for section in 0..<collectionView!.numberOfSections {

            let sectionIndexPath = IndexPath(item: 0, section: section)

            if let headerLayoutAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: sectionIndexPath)
                , headerLayoutAttributes.frame.size.isDisplayable && headerLayoutAttributes.frame.intersects(rect) {
                result.append(headerLayoutAttributes)
            }

            for item in 0..<collectionView!.numberOfItems(inSection: section) {

                if let itemLayoutAttributes = layoutAttributesForItem(at: IndexPath(item: item, section: section)) {
                    if rect.intersects(itemLayoutAttributes.frame) {
                        result.append(itemLayoutAttributes)
                    }
                }
            }

            if let footerLayoutAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: sectionIndexPath)
                , footerLayoutAttributes.frame.size.isDisplayable && footerLayoutAttributes.frame.intersects(rect) {
                result.append(footerLayoutAttributes)
            }
        }

        return result
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        return cellAttributes[indexPath]
    }

    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        switch elementKind {

        case UICollectionView.elementKindSectionHeader:
            return headerAttributes[indexPath]

        case UICollectionView.elementKindSectionFooter:
            return footerAttributes[indexPath]

        default:
            assertionFailure()
            return nil
        }
    }

    // MARK: Delegate Helpers

    private func referenceSizeForHeaderInSection(_ section:Int) -> CGSize {

        guard let headerSize = delegate?.collectionView?(collectionView!, layout: self, referenceSizeForHeaderInSection: section) else {
            return headerReferenceSize
        }

        return headerSize
    }

    private func heightForRowInSection(_ section:Int) -> CGFloat? {

        if let rowHeight = rowReferenceSize {
            return rowHeight
        }

        return delegate?.collectionView?(collectionView!, layout: self, heightForRowInSectionAtIndex: section)
    }

    private func heightForItemAtIndexPath(_ indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat? {

        return delegate?.collectionView?(collectionView!, layout: self, heightForItemAtIndexPath: indexPath, itemWidth: itemWidth)
    }

    private func referenceSizeForFooterInSection(_ section:Int) -> CGSize {

        guard let footerSize = delegate?.collectionView?(collectionView!, layout: self, referenceSizeForFooterInSection: section) else {
            return footerReferenceSize
        }

        return footerSize
    }

    private func numberOfColumnsInSection(_ section: Int) -> Int {

        guard let numberOfCols = delegate?.collectionView?(collectionView!, layout: self, numberOfColumnsForSectionAtIndex: section) else {
            return self.numberOfCols
        }

        return numberOfCols
    }

    private func insetForSection(_ section: Int) -> UIEdgeInsets {

        guard let sectionInset = delegate?.collectionView?(collectionView!, layout: self, insetForSectionAt: section) else {
            return self.sectionInset
        }

        return sectionInset
    }

    private func borderWidthForSection(_ section: Int) -> CGFloat {

        if let sectionBorderWidth = sectionBorderWidth {
            return sectionBorderWidth
        }

        if let sectionBorderWidth = delegate?.collectionView?(collectionView!, layout: self, borderWidthForSectionAtIndex: section) {
            return sectionBorderWidth
        }

        return 0
    }

    private func borderColorForSection(_ section: Int) -> UIColor {

        if let sectionBorderColor = sectionBorderColor {
            return sectionBorderColor
        }

        if let sectionBorderColor = delegate?.collectionView?(collectionView!, layout: self, borderColorForSectionAtIndex: section) {
            return sectionBorderColor
        }

        return .clear
    }

    private func minimumLineSpacingForSection(_ section: Int) -> CGFloat {

        guard let minimumLineSpacing = delegate?.collectionView?(collectionView!, layout: self, minimumLineSpacingForSectionAt: section) else {
            return self.minimumLineSpacing
        }

        return minimumLineSpacing
    }

    private func minimumInteritemSpacingForSection(_ section: Int) -> CGFloat {

        guard let minimumInteritemSpacing = delegate?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) else {
            return self.minimumInteritemSpacing
        }

        return minimumInteritemSpacing
    }
}

private extension CGSize {

    var isDisplayable: Bool {
        return width > 0 && height > 0
    }
}
