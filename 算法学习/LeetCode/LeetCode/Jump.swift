//
//  Jump.swift
//  LeetCode
//
//  Created by jourhuang on 2021/4/24.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/jump-game-ii/
// [2,3,1,1,4]


func jump(_ nums: [Int]) -> Int {
    if nums.count < 2 {
        return 0
    }
    var steps = 0
    var end = 0
    var maxRange = 0
    for i in 0 ..< nums.count - 1 {
        maxRange = max(maxRange, nums[i] + i)
        if i == end {
            end = maxRange
            steps += 1
        }
    }
    return steps
}
