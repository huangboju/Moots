//
//  DefaultCollectionViewCell.swift
//  TableExample
//
//  Created by Malte Schonvogel on 24.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

class DefaultCollectionViewCell: UICollectionViewCell {

    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? .offWhite : .white
        }
    }

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .offWhite : .white
        }
    }
}
