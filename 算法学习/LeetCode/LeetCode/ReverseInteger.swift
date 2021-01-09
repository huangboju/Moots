//
//  ReverseInteger.swift
//  LeetCode
//
//  Created by jourhuang on 2021/1/9.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func reverse(_ x: Int) -> Int {
    //反转后的整数
    var result = 0
    var del = x
    while del != 0 {
        let a = del % 10
        del /= 10
        result = result * 10 + a
    }
    if result > Int32.max || result < Int32.min {
        return 0
    }
    
    return result
}

