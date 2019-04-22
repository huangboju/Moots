//
//  FractionToDecimal.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/4/21.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

func fractionToDecimal(_ numerator: Int, _ denominator: Int) -> String {
    let n = numerator / denominator
    if n * denominator == numerator {
        return n.description
    }
    let m = Double(numerator) / Double(denominator)
    return m.description
}
