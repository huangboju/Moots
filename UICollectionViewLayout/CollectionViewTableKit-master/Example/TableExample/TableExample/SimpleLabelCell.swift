//
//  SimpleLabelCell.swift
//
//  Created by Malte Schonvogel on 5/10/17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

class SimpleLabelCell: UICollectionViewCell {

    static var viewReuseIdentifier = "SimpleLabelCell"

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    private let titleLabel = UILabel()

    override init(frame: CGRect) {

        super.init(frame: frame)

        contentView.backgroundColor = .white

        var views = [String: UIView]()

        views["title"] = titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        let constraints = [
            "H:|-[title]-|",
            "V:|[title]|",
            ].flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: nil, views: views)
        }

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
}
