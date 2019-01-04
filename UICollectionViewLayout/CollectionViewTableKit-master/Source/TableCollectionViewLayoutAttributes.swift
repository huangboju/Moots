//
//  TableCollectionViewLayoutAttributes.swift
//  CollectionViewTableKit
//
//  Created by Malte Schonvogel on 23.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import Foundation

class TableCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes {

    var borderColor: UIColor = .clear
    var borderWidth: CGFloat = 0

    override func copy(with zone: NSZone? = nil) -> Any {

        let newAttributes = super.copy(with: zone) as! TableCollectionViewLayoutAttributes

        newAttributes.borderColor = borderColor.copy(with: zone) as! UIColor
        newAttributes.borderWidth = borderWidth

        return newAttributes
    }
}
