//
//  TopHeaderView.swift
//  TableExample
//
//  Created by Malte Schonvogel on 24.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

class TopHeaderView: UIView {

    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    private let imageView = UIImageView()

    private let titleLabel = UILabel()

    override init(frame: CGRect) {

        super.init(frame: frame)

        clipsToBounds = true
        backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
}
