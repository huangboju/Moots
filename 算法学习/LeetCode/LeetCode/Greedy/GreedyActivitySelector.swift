//
//  GreedyActivitySelector.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2018/10/19.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import Foundation


let count = [3, 0, 2, 1, 0, 3, 5]
let value = [1, 2, 5, 10, 20, 50, 100]

func solve(_ money: Int) -> Int {
    var money = money
    var num = 0
    for i in (0 ..< 7).reversed() {
        let c = min(money/value[i], count[i])
        money = money - c * value[i]
        num += c
    }
    if money > 0 { num = -1 }
    return num
}

