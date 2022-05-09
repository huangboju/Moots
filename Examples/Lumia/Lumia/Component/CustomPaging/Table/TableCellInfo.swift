//
//  TableCellInfo.swift
//  CustomPaging
//
//  Created by Ilya Lobanov on 04/08/2018.
//  Copyright © 2018 Ilya Lobanov. All rights reserved.
//

import UIKit

struct TableCellInfo {
    var text: String
    var textColor: UIColor
    var bgColor: UIColor
    var height: CGFloat
    var font: UIFont
}

extension UITableViewCell {
    
    func update(with info: TableCellInfo) {
        textLabel?.textAlignment = .center
        textLabel?.text = info.text
        textLabel?.textColor = info.textColor
        textLabel?.font = info.font
        backgroundColor = info.bgColor
    }
    
}
