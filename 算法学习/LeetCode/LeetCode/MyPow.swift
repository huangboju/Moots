//
//  MyPow.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2021/4/27.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/powx-n/submissions/
func myPow(_ x: Double, _ n: Int) -> Double {
    var result: Double = 1
    
    var x = x
    var n = n
    
    if n < 0 { /// 如果小于 0
        x = 1 / x
        n = -n
    }

    while n > 0 {
        if n % 2 == 1 {
            /// 有余数，说明是奇数
            result = result * x
        }

        /// 二倍
        x *= x

        /// 除一半
        n /= 2
    }
    
    return result
}

// 5 / 2 = 2 2/ 2 = 1 1/2 = 0
