//
//  PermuteUnique.swift
//  LeetCode
//
//  Created by jourhuang on 2021/4/4.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/permutations-ii/submissions/
func permuteUnique(_ nums: [Int]) -> [[Int]] {
    func backTrack(_ nums: [Int], _ row: inout [Int], _ used: inout [Bool], _ result: inout [[Int]]) {
        if row.count == nums.count {
            result.append(row)
            return
        }
        
        for (i, n) in nums.enumerated() {
            if used[i] || (i > 0 && nums[i] == nums[i - 1] && !used[i - 1]) {
                continue
            }
            
            used[i] = true
            row.append(n)
            backTrack(nums, &row, &used, &result)
            row.removeLast()
            used[i] = false
        }
    }

    var result: [[Int]] = []
    var row: [Int] = []
    var used: [Bool] = Array(repeating: false, count: nums.count)
    backTrack(nums.sorted(), &row, &used, &result)
    return result
}
