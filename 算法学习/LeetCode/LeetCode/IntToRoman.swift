//
//  IntToRoman.swift
//  LeetCode
//
//  Created by jourhuang on 2021/1/9.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func intToRoman(_ num: Int) -> String {
    let map = [
        (1, "I"),
        (4, "IV"),
        (5, "V"),
        (9, "IX"),
        (10, "X"),
        (40, "XL"),
        (50, "L"),
        (90, "XC"),
        (100, "C"),
        (400, "CD"),
        (500, "D"),
        (900, "CM"),
        (1000, "M")
    ]
    var result = ""
    var n = num
    for (k, v) in map.reversed() {
        while k <= n {
            n -= k
            result.append(v)
        }
    }
    return result
}
