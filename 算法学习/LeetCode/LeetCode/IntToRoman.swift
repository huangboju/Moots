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

func romanToInt(_ s: String) -> Int {
    let map: [String.Element: Int] = [
        "I": 1,
        "V": 5,
        "X": 10,
        "L": 50,
        "C": 100,
        "D": 500,
        "M": 1000,
    ]

    var result = 0
    let chars = Array(s)
    var pre = map[chars[0]] ?? 0
    for char in chars.dropFirst() {
        let n = map[char] ?? 0
        if n > pre {
            result -= pre
        } else {
            result += pre
        }
        pre = n
    }
    result += pre
    return result
}
