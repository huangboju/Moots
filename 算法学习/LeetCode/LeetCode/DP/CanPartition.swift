//
//  CanPartition.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/5/15.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

func canPartition(_ nums: [Int]) -> Bool {
    let sum = nums.reduce(0, +)
    guard sum % 2 == 0 else {
        return false
    }
    let target = sum / 2
    
    var memo: [[Bool]] = Array(repeating: Array(repeating: false, count: target + 1), count: nums.count + 1)
    for i in 1 ... nums.count {
        for j in 1 ... target {
            if j - nums[i - 1] < 0 {
                memo[i][j] = memo[i-1][j]
            } else {
                memo[i][j] = memo[i-1][j] || memo[i][j - nums[i - 1]]
            }
        }
    }
    return memo[nums.count][target]
}

func _canPartition(_ nums: [Int]) -> Bool {
    let sum = nums.reduce(0, +)
    guard sum % 2 == 0 else {
        return false
    }
    let target = sum / 2
    
    var dp = Array(repeating: false, count: target + 1)
    dp[0] = true
    for n in nums {
        for j in (0 ... target).reversed() {
            if j >= n {
                dp[j] = dp[j] || dp[j - n]
            }
        }
    }
    return dp[target]
}
