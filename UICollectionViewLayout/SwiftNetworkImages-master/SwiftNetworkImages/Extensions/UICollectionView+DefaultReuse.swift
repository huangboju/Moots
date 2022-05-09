//
//  UICollectionView+DefaultReuseIdentifier.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/// Conformance to the `ReusableViewWithDefaultIdentifierAndKind` protocol
extension UICollectionReusableView: ReusableViewWithDefaultIdentifierAndKind {}

/** 
    Simplifies registering & dequeuing `UICollectionViewCell` and `UICollectionReusableView` classes & nibs.
 
    Sample usage: 
 
    ```
    class ImageCollectionViewCell: UICollectionViewCell {}

    collectionView.registerClass(ImageCollectionViewCell.self)

    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        // ...
        return cell
    }

    ```
*/
extension UICollectionView {
    // MARK: - Register classes
    func registerClass<T: UICollectionViewCell>(_: T.Type)
                                        where T: ReusableViewWithDefaultIdentifier {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    func registerClass<T: UICollectionReusableView>(_: T.Type,
                       forSupplementaryViewOfKind elementKind: String)
                                        where T: ReusableViewWithDefaultIdentifier {
        register(T.self, forSupplementaryViewOfKind: elementKind,
                                                withReuseIdentifier: T.defaultReuseIdentifier)
    }
    func registerClass<T: UICollectionReusableView>(_: T.Type)
        where T: ReusableViewWithDefaultIdentifierAndKind {
        register(T.self, forSupplementaryViewOfKind: T.defaultElementKind,
                                                withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    // MARK: - Register nibs
    func registerNib<T: UICollectionViewCell>(_: T.Type)
                                        where T: ReusableViewWithDefaultIdentifier, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    func registerNib<T: UICollectionReusableView>(_: T.Type,
                     forSupplementaryViewOfKind elementKind: String)
                                        where T: ReusableViewWithDefaultIdentifier, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: Bundle(for: T.self))
        register(nib, forSupplementaryViewOfKind: elementKind,
                                                withReuseIdentifier: T.defaultReuseIdentifier)
    }
    func registerNib<T: UICollectionReusableView>(_: T.Type)
                                        where T: ReusableViewWithDefaultIdentifierAndKind, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: Bundle(for: T.self))
        register(nib, forSupplementaryViewOfKind: T.defaultElementKind,
                                                withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    // MARK: - Cells dequeueing
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T
                                        where T: ReusableViewWithDefaultIdentifier {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier,
                                             for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    // MARK: - Dequeueing of reusable views
    func dequeueReusableSupplementaryViewOfKind<T: UICollectionReusableView> (elementKind: String,
                                                for indexPath: IndexPath)  -> T
                                        where T: ReusableViewWithDefaultIdentifier {
         let reuseIdentifier = T.defaultReuseIdentifier
        guard let reusableView = dequeueReusableSupplementaryView(ofKind: elementKind,
                                                                  withReuseIdentifier: reuseIdentifier,
                                                                  for: indexPath as IndexPath) as? T else {
            fatalError(String(format: "%@%@", "Could not dequeue reusable view of kind \(elementKind)",
                                                                     "with identifier: \(T.defaultReuseIdentifier)"))
        }
        return reusableView
    }
    
    func dequeueReusableSupplementaryViewOfKind<T: UICollectionReusableView> (for indexPath: IndexPath)  -> T
                                        where T: ReusableViewWithDefaultIdentifierAndKind {
            guard let reusableView = dequeueReusableSupplementaryView(ofKind: T.defaultElementKind,
                                                                      withReuseIdentifier: T.defaultReuseIdentifier,
                                                                      for: indexPath as IndexPath) as? T else {
            fatalError(String(format: "%@%@", "Could not dequeue reusable view of kind \(T.defaultElementKind)",
                                                                    "with identifier: \(T.defaultReuseIdentifier)"))
        }
        return reusableView
    }
}









