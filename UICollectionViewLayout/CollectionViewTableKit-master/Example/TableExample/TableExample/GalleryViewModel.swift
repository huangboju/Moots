//
//  GalleryViewModel.swift
//  TableExample
//
//  Created by Malte Schonvogel on 07.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

struct GalleryViewModel: CellRepresentable {

    let images: [UIImage]

    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier, for: indexPath) as! GalleryCell
        cell.content = images

        return cell
    }

    func itemHeight(forWidth width: CGFloat, indexPath: IndexPath) -> CGFloat {

        return isIpad ? 200 : 150
    }
}
