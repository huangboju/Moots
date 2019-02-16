//
//  DecorationView.swift
//  DynamicsCatalog
//
//  Created by 黄伯驹 on 2019/2/16.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class DecorationView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(patternImage: UIImage(named: "BackgroundTile")!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
