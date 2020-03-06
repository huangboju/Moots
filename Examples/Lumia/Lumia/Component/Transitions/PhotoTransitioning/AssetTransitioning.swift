/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The AssetTransitionItem class represets a data object used to pass transition information between view controllers. The AssetTransitioning protocol
                is the contract each view controller involved in the transition must conform to. This protocol gives each view controller the chance to negotiate
                what transition items it can support for a given transition.
*/

import UIKit
import Photos

class AssetTransitionItem: NSObject {
    var initialFrame: CGRect
    var image: UIImage {
        didSet {
            imageView?.image = image
        }
    }
    var indexPath: IndexPath
    var asset: PHAsset
    var targetFrame: CGRect?
    var imageView: UIImageView?
    var touchOffset: CGVector = CGVector.zero
    
    init(initialFrame: CGRect, image: UIImage, indexPath: IndexPath, asset: PHAsset) {
        self.initialFrame = initialFrame
        self.image = image
        self.indexPath = indexPath
        self.asset = asset
        super.init()
    }
}

protocol AssetTransitioning {
    func itemsForTransition(context: UIViewControllerContextTransitioning) -> Array<AssetTransitionItem>
    func targetFrame(transitionItem: AssetTransitionItem) -> CGRect?
    func willTransition(fromController: UIViewController, toController: UIViewController, items: Array<AssetTransitionItem>)
    func didTransition(fromController: UIViewController, toController: UIViewController, items: Array<AssetTransitionItem>)
}
