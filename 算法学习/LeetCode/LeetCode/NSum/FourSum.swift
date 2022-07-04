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

    for j in 0 ..< sortedNums.count {
        if j > 0 && sortedNums[j] == sortedNums[j - 1] {
            continue
        }
        for i in j + 1 ..< sortedNums.count {
            if i > j + 1 && sortedNums[i] == sortedNums[i - 1] {
                continue
            }
            var left = i + 1
            var right = sortedNums.count - 1
            while left < right {
                let sum = sortedNums[left] + sortedNums[right] + sortedNums[j] + sortedNums[i]
                if sum == target {
                    res.append([sortedNums[j], sortedNums[i], sortedNums[left], sortedNums[right]])
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
