//
//  Copyright © 2016年 cmcaifu.com. All rights reserved.
//

import UIKit

class RulerLayout: UICollectionViewFlowLayout {
    
    var usingScale = false
    
    private let _scale: CGFloat = 0.6

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let temp = super.layoutAttributesForElements(in: rect)
        if usingScale {
            for attribute in temp! {
                let distance = abs(attribute.center.x - collectionView!.frame.width * 0.5 - collectionView!.contentOffset.x)
                var scale: CGFloat = _scale
                let w = (collectionView!.frame.width + itemSize.width) * _scale
                if distance >= w {
                    scale = _scale
                } else {
                    scale = scale + (1 - distance / w) * (1 - _scale)
                }
                attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return temp
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let rect = CGRect(origin: proposedContentOffset, size: collectionView!.frame.size)
        let temp = super.layoutAttributesForElements(in: rect)
        var gap: CGFloat = 1000
        var a: CGFloat = 0
        let margin = proposedContentOffset.x + collectionView!.frame.width * 0.5
        for attribute in temp! {
            if gap > abs(attribute.center.x - margin) {
                gap = abs(attribute.center.x - margin)
                a = attribute.center.x - margin
            }
        }

        return CGPoint(x: proposedContentOffset.x + a, y: proposedContentOffset.y)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
