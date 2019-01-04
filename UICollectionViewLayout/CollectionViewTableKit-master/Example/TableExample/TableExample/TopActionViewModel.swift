//
//  TopActionViewModel.swift
//  TableExample
//
//  Created by Malte Schonvogel on 07.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

struct TopActionViewModel: CellRepresentable {

    let action: Action

    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconActionCell.identifier, for: indexPath) as! IconActionCell
        cell.content = action

        return cell
    }

    func itemHeight(forWidth width: CGFloat, indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
}
