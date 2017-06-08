//
//  Copyright © 2016年 cmcaifu.com. All rights reserved.
//

import UIKit

class MootsLayout: UICollectionViewFlowLayout {
    
//    var usingScale = false
//    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let temp = super.layoutAttributesForElements(in: rect)
//        if usingScale {
//            for attribute in temp! {
//                let distance = abs(attribute.center.x - collectionView!.frame.width * 0.5 - collectionView!.contentOffset.x)
//                var scale: CGFloat = 0.8
//                let w = (collectionView!.frame.width + itemSize.width) * 0.8
//                if distance >= w {
//                    scale = 0.8
//                } else {
//                    scale = scale + (1 - distance / w) * 0.2
//                }
//                attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
//            }
//        }
//        return temp
//    }

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
