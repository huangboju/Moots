//
//  UICollectionReusableViews.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 9/5/16.
//  Copyright © 2016 akpw. All rights reserved.
//

import UIKit

/// Simplifies registering classes & nibs into UICollectionView

/// Provides static `defaultReuseIdentifier` property
protocol ReusableViewWithDefaultIdentifier {
    static var defaultReuseIdentifier: String { get }
}
/// Generates static `defaultReuseIdentifier` property based on class name
extension ReusableViewWithDefaultIdentifier where Self: UIView {
    static var defaultReuseIdentifier: String {
        let className = String(describing: self)
        return "\(className)DefaultReuseIdentifier"
    }
}

/// Provides static `defaultElementKind` property
protocol ReusableViewWithDefaultIdentifierAndKind: ReusableViewWithDefaultIdentifier  {
    static var defaultElementKind: String { get }
}
/// Generates static `defaultElementKind` property based on class name
extension ReusableViewWithDefaultIdentifierAndKind where Self: UIView {
    static var defaultElementKind: String {
        let className = String(describing: self)
        return "\(className)DefaultElementKind"
    }
}

/// Provides static `nibName` property
protocol NibLoadableView {
    static var nibName: String { get }
}
/// Generates static `nibName` property based on class name
extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}


