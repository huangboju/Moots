//
//  ReverseInt.swift
//  LeetCode
//
//  Created by jourhuang on 2021/4/17.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func reverseInt(_ x: Int) -> Int {
    var n = x
    var result = 0
    
    while abs(n) > 0 {
        let m = n % 10
        result = result * 10 + m
        n /= 10
    }
    if result > Int32.max || result < Int32.min {
        return 0
    }
    return result
}
