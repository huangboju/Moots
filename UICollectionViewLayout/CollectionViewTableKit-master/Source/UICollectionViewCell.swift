//
//  UICollectionViewCell.swift
//  CollectionViewTableKit
//
//  Created by Malte Schonvogel on 30.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

extension UICollectionViewCell {

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {

        super.apply(layoutAttributes)

        guard let attributes = layoutAttributes as? TableCollectionViewLayoutAttributes else {
            layer.borderWidth = 0
            layer.borderColor = nil
            return
        }

        layer.borderWidth = attributes.borderWidth
        layer.borderColor = attributes.borderColor.cgColor
    }
}
