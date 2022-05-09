//
//  LengthOfLIS.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/5/6.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

/// https://leetcode-cn.com/problems/longest-increasing-subsequence/
func lengthOfLIS(_ nums: [Int]) -> Int {
    var dp: [Int] = Array(repeating: 1, count: nums.count)
    
    for i in 0 ..< nums.count {
        for j in 0 ..< i {
            if nums[i] > nums[j] {
                dp[i] = max(dp[i], dp[j] + 1)
            }
        }
    }
    
    return dp.max() ?? 0
}


// https://leetcode-cn.com/problems/longest-continuous-increasing-subsequence/
//输入: [1,3,5,4,7]
//输出: 3
//解释: 最长连续递增序列是 [1,3,5], 长度为3。
//尽管 [1,3,5,7] 也是升序的子序列, 但它不是连续的，因为5和7在原数组里被4隔开。


func findLengthOfLCIS(_ nums: [Int]) -> Int {
    if nums.isEmpty { return 0 }
    var result = 1
    var maxLength = 1
    for i in 1..<nums.count {
        if nums[i-1] < nums[i] {
            result += 1
            maxLength = max(maxLength, result)
        } else {
            result = 1
        }
    }
    return maxLength
}
