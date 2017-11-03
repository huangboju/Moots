//
//  HZUIHelper.swift
//  HtinnsFlat
//
//  Created by 黄伯驹 on 2017/11/2.
//  Copyright © 2017年 hangting. All rights reserved.
//

import UIKit

class HZUIHelper {

    static func generateNormalButton(with title: String? = nil, target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitle(title, for: .normal)
        return button
    }
    
    static func generateNormalButton(with imageName: String, target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
