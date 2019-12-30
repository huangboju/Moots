//
//  TableViewHeaderFooterView.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 16/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class TableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    lazy var customLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)        
        contentView.addSubview(customLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customLabel.frame = contentView.bounds
    }
}
