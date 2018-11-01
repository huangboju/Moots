//
//  SampleImagesDataSourceDelegate.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 4/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit


/// Implements UICollectionViewDataSource and UICollectionViewDelegate methods 
/// for `SampleImagesViewController`'s collectionView

class SampleImagesDataSourceDelegate: NSObject, UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _imagesDataSource?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _imagesDataSource?.numberOfImageItemsInSection(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let imageViewModel = _imagesDataSource?.imageViewModelForItemAtIndexPath(indexPath: indexPath as NSIndexPath) {
            cell.imageVewModel = imageViewModel
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                                      at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let header: ImageCollectionViewGlobalHeader =
                collectionView.dequeueReusableSupplementaryViewOfKind(
                                                            elementKind: UICollectionElementKindSectionHeader,
                                                            for: indexPath)
            return header
        } else {
            let header: ImageCollectionViewHeader =
                collectionView.dequeueReusableSupplementaryViewOfKind(
                                                            elementKind: UICollectionElementKindSectionHeader,
                                                            for: indexPath)
            header.sectionHeaderText = _imagesDataSource?.headerInSection(section: indexPath.section)
            return header
        }
    }
    
    // MARK: - 🕶Private
    fileprivate var _imagesDataSource: ImagesDataSource?
    fileprivate var _parentVC: UIViewController?
    fileprivate var _selectedFrame = CGRect.zero
}

extension SampleImagesDataSourceDelegate: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return ImageDetailPresentationController(presentedViewController: presented, presenting: source)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageDetailDismissAnimator()
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = ImageDetailPresentAnimator()
        animator.sourceFrame = _selectedFrame
        return animator
    }    
}

extension SampleImagesDataSourceDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailImageVC = SampleImageDetailVC()
        detailImageVC.transitioningDelegate = self
        detailImageVC.modalPresentationStyle = .custom
        if let imageViewModel = _imagesDataSource?.imageViewModelForItemAtIndexPath(indexPath: indexPath as NSIndexPath) {
            detailImageVC.imageVewModel = imageViewModel
        }
        
        guard let cellAttributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let attributesFrame = cellAttributes.frame
        _selectedFrame = collectionView.convert(attributesFrame, to: nil)
        _parentVC?.present(detailImageVC, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {return CGSize.zero }
        let sectionInsetWidth = self.collectionView(collectionView, layout: layout,
                                                    insetForSectionAt: indexPath.section).left
        let width = collectionView.bounds.width / 2 - layout.minimumInteritemSpacing / 2 - sectionInsetWidth
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 80)
        }
        else {
            return CGSize(width: collectionView.frame.size.width, height: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

extension SampleImagesDataSourceDelegate: DependencyInjectable {
    // MARK: - 🔌Dependencies injection
    typealias ExternalDependencies = (imagesDataSource: ImagesDataSource, parentVC: UIViewController)
    func inject(_ dependencies: ExternalDependencies) {
        self._imagesDataSource = dependencies.imagesDataSource
        self._parentVC = dependencies.parentVC
    }
}





