//
//  CustomCollectionViewCell.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 12/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()

    lazy var enabledLabel: UIView = {
        let label = UILabel()
        label.text = "Enabled"
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.addSubview(enabledLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
        enabledLabel.frame = contentView.bounds
    }
}
