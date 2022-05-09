//
//  TableViewCellItem.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 05/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class TableViewCellItem {
    
    typealias Handler = (() -> Void)
    
    var title: String
    var enabled: Bool
    var switchable: Bool
    var custom: Bool
    var height: CGFloat
    var selectionHandler: Handler?

    init(title: String,
         custom: Bool = false,
         switchable: Bool = false,
         enabled: Bool = false,
         height: CGFloat = 44.0,
         selectionHandler: Handler? = nil) {
        self.title = title
        self.custom = custom
        self.switchable = switchable
        self.enabled = enabled
        self.height = height
        self.selectionHandler = selectionHandler
    }
}
