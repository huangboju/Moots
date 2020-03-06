/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    AssetViewController's implementation of the AssetTransitioning protocol used as the handshaking mechanism when transitioning.
*/

import UIKit
import Photos
import AVKit


extension AssetViewController: AssetTransitioning {
    
    func itemsForTransition(context: UIViewControllerContextTransitioning) -> Array<AssetTransitionItem> {
        guard let collectionView = self.collectionView else { return [] }
        
        var indexPaths = collectionView.indexPathsForVisibleItems
        if context.isInteractive {
            if let indexPath = collectionView.indexPathForItem(at: collectionView.panGestureRecognizer.location(in: collectionView)) {
                indexPaths = [indexPath]
            }
        }
        
        return indexPaths.map({ (indexPath: IndexPath) -> AssetTransitionItem in
            let cell = collectionView.cellForItem(at: indexPath) as! AssetCell
            let asset = self.fetchResult.object(at: indexPath.item)
            let initialFrame: CGRect
            
            switch self.layoutStyle {
            case .oneUp:
                let boundingRect = cell.imageView.convert(cell.imageView.bounds, to: nil)
                let aspectRatio = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                initialFrame = AVMakeRect(aspectRatio: aspectRatio, insideRect: boundingRect)
            case .grid:
                initialFrame = cell.convert(cell.bounds, to: nil)
            }
            
            return AssetTransitionItem(initialFrame: initialFrame, image: cell.imageView.image!, indexPath: indexPath, asset: asset)
        })
    }
    
    func targetFrame(transitionItem item: AssetTransitionItem) -> CGRect? {
        guard let collectionView = self.collectionView else { return nil }
        
        switch self.layoutStyle {
        case .oneUp:
            if item.asset.localIdentifier == self.transitioningAsset?.localIdentifier {
                let boundingRect = self.view.convert(self.view.bounds, to: nil)
                let aspectRatio = CGSize(width: item.asset.pixelWidth, height: item.asset.pixelHeight)
                return AVMakeRect(aspectRatio: aspectRatio, insideRect: boundingRect)
            }
        case .grid:
            if !collectionView.indexPathsForVisibleItems.contains(item.indexPath) {
                collectionView.scrollToItem(at: item.indexPath, at: .centeredVertically, animated: false)
                collectionView.layoutIfNeeded()
            }
            
            if let cell = collectionView.cellForItem(at: item.indexPath) as? AssetCell {
                if cell.assetIdentifier == item.asset.localIdentifier {
                    return cell.convert(cell.bounds, to: nil)
                }
            }
        }
        
        return nil
    }
    
    func willTransition(fromController: UIViewController, toController: UIViewController, items: Array<AssetTransitionItem>) {
        guard let collectionView = self.collectionView else { return }
        
        switch self.layoutStyle {
        case .oneUp:
            collectionView.alpha = 0.0
            collectionView.panGestureRecognizer.isEnabled = false
            if self == toController {
                if let asset = items.last?.asset {
                    let indexPath = IndexPath(row: fetchResult.index(of: asset), section: 0)
                    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                }
            }
        case .grid:
            let options = PHImageRequestOptions()
            options.deliveryMode = .opportunistic
            options.isNetworkAccessAllowed = true
            
            for item in items {
                collectionView.cellForItem(at: item.indexPath)?.alpha = 0.0
                
                // Update the image resolution
                if self == fromController {
                    self.imageManager.requestImage(for: item.asset, targetSize: item.targetFrame!.size, contentMode: .aspectFit, options: options, resultHandler: { [weak item] (result, _) in
                        if let image = result {
                            item?.image = image
                        }
                    })
                }
            }
        }
    }
    
    func didTransition(fromController: UIViewController, toController: UIViewController, items: Array<AssetTransitionItem>) {
        guard let collectionView = self.collectionView else { return }
        
        switch self.layoutStyle {
        case .oneUp:
            collectionView.alpha = 1.0
            collectionView.panGestureRecognizer.isEnabled = true
        case .grid:
            for item in items {
                collectionView.cellForItem(at: item.indexPath)?.alpha = 1.0
            }
        }
    }
}
