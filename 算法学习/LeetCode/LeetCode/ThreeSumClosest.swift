//
//  ThreeSumClosest.swift
//  LeetCode
//
//  Created by jourhuang on 2021/1/10.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/3sum-closest/

func threeSumClosest(_ nums: [Int], _ target: Int) -> Int {
    let sortedNums = nums.sorted()
    var result = nums[0] + nums[1] + nums[2]
    for (i, n) in sortedNums.enumerated() {
        var start = i + 1
        var end = sortedNums.count - 1
        while start < end {
            let sum = sortedNums[start] + sortedNums[end] + n
            if sum == target {
                return sum
            } else if abs(target - sum) < abs(target - result) {
                result = sum
            }
            if sum < target {
                start += 1
            } else {
                end -= 1
            }
        }
    }
    return result
}
