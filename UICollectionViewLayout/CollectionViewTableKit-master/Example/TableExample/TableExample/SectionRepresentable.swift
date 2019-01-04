//
//  SectionRepresentable.swift
//  TableExample
//
//  Created by Malte Schonvogel on 07.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

protocol SectionRepresentable {

    var title: String? { get set }
    var numberOfItems: Int { get }
    func headerInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView
    func headerHeight(forWidth width: CGFloat) -> CGFloat
}
