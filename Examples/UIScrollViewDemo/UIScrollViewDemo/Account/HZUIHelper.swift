//
//  HZUIHelper.swift
//  HtinnsFlat
//
//  Created by 黄伯驹 on 2017/11/2.
//  Copyright © 2017年 hangting. All rights reserved.
//

import UIKit

class HZUIHelper {

    static func generateNormalButton(with target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
