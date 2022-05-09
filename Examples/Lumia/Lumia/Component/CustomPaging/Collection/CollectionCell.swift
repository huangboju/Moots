//
//  CollectionCell.swift
//  CustomPaging
//
//  Created by Ilya Lobanov on 26/08/2018.
//  Copyright © 2018 Ilya Lobanov. All rights reserved.
//

import UIKit

final class CollectionCell: UICollectionViewCell {

    struct Info {
        var text: String
        var textColor: UIColor
        var bgColor: UIColor
        var size: CGSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(textLabel)
        textLabel.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with info: Info) {
        textLabel.textAlignment = .center
        textLabel.text = info.text
        textLabel.textColor = info.textColor
        contentView.backgroundColor = info.bgColor
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = contentView.bounds
        contentView.layer.cornerRadius = contentView.bounds.height / 2
    }
    
    // MARK: - Private
    
    private let textLabel = UILabel()
    
}
