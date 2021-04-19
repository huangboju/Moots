//
//  IsPalindromeInt.swift
//  LeetCode
//
//  Created by jourhuang on 2021/4/17.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func isPalindromeInt(_ x: Int) -> Bool {
    let str = String(x)
    return Array(str) == str.reversed()
}
