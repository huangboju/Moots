//
//  Model.swift
//  LazyLoad
//
//  Created by 伯驹 黄 on 2017/4/10.
//  Copyright © 2017年 xiAo_Ju. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias DATA = JSON

struct Model {
    var height: CGFloat
    var hoverURL: String
    var width: CGFloat

    init(_ dict: [String: DATA]) {
        height = CGFloat(dict["height"]?.float ?? 0)
        hoverURL = dict["hoverURL"]?.stringValue ?? ""
        width = CGFloat(dict["width"]?.float ?? 0)
    }
}
