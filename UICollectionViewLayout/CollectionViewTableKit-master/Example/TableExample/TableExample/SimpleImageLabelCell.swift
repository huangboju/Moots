//
//  SimpleImageLabelCell.swift
//
//  Created by Malte Schonvogel on 5/10/17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

class SimpleImageLabelCell: UICollectionViewCell {

    static var viewReuseIdentifier = "SimpleImageLabelCell"

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    private let titleLabel = UILabel()

    private let imageView = UIImageView()

    override init(frame: CGRect) {

        super.init(frame: frame)

        contentView.backgroundColor = .white

        var views = [String: UIView]()

        views["title"] = titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        views["image"] = imageView
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        let constraints = [
            "H:|[image]-[title]-|",
            "V:|[image]|",
            "V:|[title]|",
            ].flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: nil, views: views)
        } + [
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
