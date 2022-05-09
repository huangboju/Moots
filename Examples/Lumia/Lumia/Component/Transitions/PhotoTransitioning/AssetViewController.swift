/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The AssetViewController is a basic view controller created to display a grid of photos or a one-up presentation of a single photo.
*/

import UIKit
import Photos

private let reuseIdentifier = "Cell"

enum AssetLayoutStyle {
    case grid
    case oneUp
    
    private func itemSize(inBoundingSize size: CGSize) -> (itemSize: CGSize, lineSpacing: Int) {
        var length = 0
        let w = Int(size.width)
        var spacing = 1
        for i in 1...3 {
            for n in 4...8 {
                let x = w - ((n-1) * i)
                if x % n == 0 && (x/n) > length {
                    length = x/n
                    spacing = i
                }
            }
        }
        
        return (CGSize(width: length, height: length), spacing)
    }
    
    func recalculate(layout: UICollectionViewFlowLayout, inBoundingSize size: CGSize) {
        switch self {
        case .grid:
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 1
            layout.sectionInset = UIEdgeInsets.zero
            let itemInfo = self.itemSize(inBoundingSize: size)
            layout.minimumLineSpacing = CGFloat(itemInfo.lineSpacing)
            layout.itemSize = itemInfo.itemSize
        case .oneUp:
            layout.minimumLineSpacing = 40
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.scrollDirection = .horizontal;
            layout.itemSize = size
        }
    }
}

class AssetViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching {
    
    let layoutStyle: AssetLayoutStyle
    let fetchResult: PHFetchResult<PHAsset>
    let imageManager: PHCachingImageManager
    let queue: DispatchQueue
    
    var assetSize: CGSize = CGSize.zero
    var transitioningAsset: PHAsset?
    var sizeTransitionIndexPath: IndexPath?

    // MARK: Initializers
    init(layoutStyle: AssetLayoutStyle, fetchResult: PHFetchResult<PHAsset>? = nil, imageManager: PHCachingImageManager? = nil) {
        self.layoutStyle = layoutStyle
    
        if let fetchResult = fetchResult {
            self.fetchResult = fetchResult
        } else {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            self.fetchResult = PHAsset.fetchAssets(with: options)
        }
        
        if let imageManager = imageManager {
            self.imageManager = imageManager
        } else {
            self.imageManager = PHCachingImageManager()
        }
        
        queue = DispatchQueue(label: "com.photo.prewarm", qos: .default, attributes: [.concurrent], autoreleaseFrequency: .inherit, target: nil)
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private var flowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    private func recalculateItemSize(inBoundingSize size: CGSize) {
        layoutStyle.recalculate(layout: flowLayout, inBoundingSize: size)
        let itemSize = flowLayout.itemSize
        let scale = UIScreen.main.scale
        assetSize = CGSize(width: itemSize.width * scale, height: itemSize.height * scale);
    }
    
    // MARK:

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        if let collectionView = self.collectionView {
            collectionView.register(AssetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            collectionView.isPrefetchingEnabled = true
            collectionView.prefetchDataSource = self
            collectionView.backgroundColor = UIColor.clear
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        recalculateItemSize(inBoundingSize: self.view.bounds.size)
        
        switch layoutStyle {
        case .grid:
            title = "All Photos"
        case .oneUp:
            self.automaticallyAdjustsScrollViewInsets = false
            self.collectionView?.isPagingEnabled = true
            self.collectionView?.frame = view.frame.insetBy(dx: -20.0, dy: 0.0)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        recalculateItemSize(inBoundingSize: size)
        if view.window == nil {
            view.frame = CGRect(origin: view.frame.origin, size: size)
            view.layoutIfNeeded()
        } else {
            let indexPath = self.collectionView?.indexPathsForVisibleItems.last
            coordinator.animate(alongsideTransition: { ctx in
                self.collectionView?.layoutIfNeeded()
            }, completion: { _ in
                if self.layoutStyle == .oneUp, let indexPath = indexPath {
                    self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                }
            })
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AssetCell
        
        if layoutStyle == .oneUp {
            cell.imageView.contentMode = .scaleAspectFit;
        }
        
        let asset = fetchResult.object(at: indexPath.item)
        cell.assetIdentifier = asset.localIdentifier
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        
        self.imageManager.requestImage(for: asset, targetSize: self.assetSize, contentMode: .aspectFit, options: options) { (result, info) in
            if (cell.assetIdentifier == asset.localIdentifier) {
                cell.imageView.image = result
            }
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if layoutStyle == .grid {
            let assetViewController = AssetViewController(layoutStyle: .oneUp, fetchResult: fetchResult, imageManager: imageManager)
            assetViewController.flowLayout.itemSize = view.bounds.size
            assetViewController.transitioningAsset = fetchResult.object(at: indexPath.item)
            navigationController?.pushViewController(assetViewController, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard layoutStyle == .oneUp, let indexPath = collectionView.indexPathsForVisibleItems.last, let layoutAttributes = flowLayout.layoutAttributesForItem(at: indexPath) else {
            return proposedContentOffset
        }
        
        return CGPoint(x: layoutAttributes.center.x - (layoutAttributes.size.width / 2.0) - (flowLayout.minimumLineSpacing / 2.0), y: 0)
    }
    
    // MARK: UICollectionViewDataSourcePrefetching
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        queue.async {
            self.imageManager.startCachingImages(for: indexPaths.map{self.fetchResult.object(at: $0.item)}, targetSize: self.assetSize, contentMode: .aspectFill, options: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        queue.async {
            self.imageManager.stopCachingImages(for: indexPaths.map{self.fetchResult.object(at: $0.item)}, targetSize: self.assetSize, contentMode: .aspectFill, options: nil)
        }
    }
}
