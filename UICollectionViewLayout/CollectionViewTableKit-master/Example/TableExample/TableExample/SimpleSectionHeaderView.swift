//
//  SimpleSectionHeaderView.swift
//
//  Created by Malte Schonvogel on 5/10/17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//
import UIKit

class SimpleSectionHeaderView: UICollectionReusableView {

    static var viewReuseIdentifer = "SimpleSectionHeaderView"

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    private let titleLabel = UILabel()

    override init(frame: CGRect) {

        super.init(frame: frame)

        var views = [String: UIView]()

        views["title"] = titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

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
