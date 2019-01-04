//
//  CellRepresentable.swift
//  TableExample
//
//  Created by Malte Schonvogel on 07.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

protocol CellRepresentable {

    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func itemHeight(forWidth width: CGFloat, indexPath: IndexPath) -> CGFloat
}
