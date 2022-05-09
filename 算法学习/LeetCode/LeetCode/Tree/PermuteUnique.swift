//
//  PermuteUnique.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/3/6.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/permutations-ii/submissions/

class SolutionPermuteUnique {
    func permuteUnique(_ nums: [Int]) -> [[Int]] {
        var result: [[Int]] = []
        var path: [Int] = []
        var used: [Bool] = Array(repeating: false, count: nums.count)
        
        backtrack(nums.sorted(), &result, &path, &used)
        
        
        return result
    }
    
    func backtrack(_ nums: [Int], _ result: inout [[Int]], _ path: inout [Int], _ used: inout [Bool]) {
        if nums.count == path.count {
            result.append(path)
            return
        }
        
        for (i, n) in nums.enumerated() {
            if used[i] {
                continue
            }
            if i > 0 && nums[i] == nums[i - 1] && !used[i - 1] {
                continue
            }
            path.append(n)
            used[i] = true
            backtrack(nums, &result, &path, &used)
            path.removeLast()
            used[i] = false
        }
    }
}
