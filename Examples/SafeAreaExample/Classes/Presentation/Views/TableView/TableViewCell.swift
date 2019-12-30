//
//  TableViewCell.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 05/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    lazy var customLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(customLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        customLabel.frame.origin.x = 5.0
        customLabel.frame.origin.y = 0.0
        customLabel.frame.size.width = contentView.bounds.width - 10.0
        customLabel.frame.size.height = contentView.bounds.height
    }
}
