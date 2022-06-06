//
//  FourSum.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2021/1/26.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode.cn/problems/4sum/submissions/
func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
    if nums.count < 4 {
        return []
    }

    let sortedNums = nums.sorted()

    var res = [[Int]]()

    for x in 0 ..< sortedNums.count {
        if x > 0 && sortedNums[x] == sortedNums[x - 1] {
            continue
        }
        for i in x + 1 ..< sortedNums.count {
            if i > x + 1 && sortedNums[i] == sortedNums[i - 1] {
                continue
            }
            var left = i + 1
            var right = sortedNums.count - 1
            while left < right {
                let sum = sortedNums[left] + sortedNums[right] + sortedNums[x] + sortedNums[i]
                if sum == target {
                    res.append([sortedNums[x], sortedNums[i], sortedNums[left], sortedNums[right]])
                    while left < right && sortedNums[left] == sortedNums[left + 1] {
                        left += 1
                    }
                    while left < right && sortedNums[right] == sortedNums[right - 1] {
                        right -= 1
                    }
                }
                if sum > target {
                    
                    right -= 1
                    
                } else {
                    left += 1
                }
            }
        }
    }
    
    return res
}
