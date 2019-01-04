//
//  ReviewViewModel.swift
//  TableExample
//
//  Created by Malte Schonvogel on 02.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

struct ReviewViewModel: CellRepresentable {

    private let review: Review
    private let cellContent: ReviewCell.CellContent

    init(review: Review) {
        self.review = review
        self.cellContent = (
            author: review.author.attributedName,
            date: review.attributedCreatedAt,
            text: review.attributedText,
            avatar: review.author.avatar
        )
    }

    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.identifier, for: indexPath) as! ReviewCell
        cell.content = cellContent

        return cell
    }

    func itemHeight(forWidth width: CGFloat, indexPath: IndexPath) -> CGFloat {

        return ReviewCell.calculateHeight(content: cellContent, forWidth: width)
    }
}
