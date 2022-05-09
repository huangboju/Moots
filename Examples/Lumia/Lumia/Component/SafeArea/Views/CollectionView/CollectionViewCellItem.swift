//
//  CollectionViewCellItem.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 13/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class CollectionViewCellItem {
    
    typealias Handler = (() -> Void)

    var title: String
    var enabled: Bool
    var size: CGSize
    var selectionHandler: Handler?

    init(title: String, enabled: Bool = false, size: CGSize = .zero, selectionHandler: Handler? = nil) {
        self.title = title
        self.enabled = enabled
        self.size = size
        self.selectionHandler = selectionHandler
    }
}
