//
//  FirstMissingPositive.swift
//  LeetCode
//
//  Created by jourhuang on 2021/2/28.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation
// https://leetcode-cn.com/problems/first-missing-positive/
func firstMissingPositive(_ nums: [Int]) -> Int {
    let count = nums.count
    var nums = nums
    for (index, n) in nums.enumerated() where n <= 0 {
        nums[index] = count + 1
    }
    for index in nums where index <= count {
        nums[index-1] = -abs(nums[index-1])
    }
    return (nums.firstIndex(where: { $0 > 0 }) ?? count) + 1
}

