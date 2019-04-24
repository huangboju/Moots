//
//  MaxProduct.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/4/23.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/interview/card/top-interview-quesitons-in-2018/264/array/1126/

func maxProduct(_ nums: [Int]) -> Int {
    var result = 1
    var max = 0
    for n in nums {
        result *= n
        if result > max {
            max = result
        }
    }
    return max
}
