//
//  GexMod.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2021/12/25.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func value(from str: String) -> Int {
    var result = 0

    let zeroAscii = Character("0").asciiValue ?? 0
    let aAscii = Character("a").asciiValue ?? 0

    for char in str {
        result = result * 16 % 100
        if "0"..."9" ~= char {
            result += Int(char.asciiValue.flatMap { $0 - zeroAscii } ?? 0)
        } else if "a"..."f" ~= char {
            result += Int(char.asciiValue.flatMap { $0 - aAscii + 10 } ?? 0)
        }
    }
    return result
}

func hexMod(with str: String) -> Int {
    let target = [
        76,
        16,
        56,
        96,
        36
    ]

    var result = 0
    for (i, char) in str.reversed().enumerated() {
        let number = Int("\(char)", radix: 16)!
        if i == 0 {
            result = number
            continue
        }
        let idx = i % 5
        let n = target[idx]
        result += (number * n % 100)
    }
    result %= 100
    return result
}
