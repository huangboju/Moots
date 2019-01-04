//
//  PlaceActionViewModel.swift
//  TableExample
//
//  Created by Malte Schonvogel on 08.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

struct PlaceActionViewModel: CellRepresentable {

    let action: Action

    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconTableCell.identifier, for: indexPath) as! IconTableCell
        cell.content = action

        return cell
    }

    func itemHeight(forWidth width: CGFloat, indexPath: IndexPath) -> CGFloat {

        return IconTableCell.calculateHeight(content: action, forWidth: width)
    }
}
