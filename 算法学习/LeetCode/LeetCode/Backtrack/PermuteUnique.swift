//
//  PermuteUnique.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/3/6.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode.cn/problems/permutations-ii/

class SolutionPermuteUnique {
    var result: [[Int]] = []
    
    var path: [Int] = []
    
    var used: [Bool] = []
    
    func permuteUnique(_ nums: [Int]) -> [[Int]] {
        used = Array(repeating: false, count: nums.count)
        backtrack(nums.sorted())
        return result
    }

    func backtrack(_ nums: [Int]) {
        if path.count == nums.count {
            result.append(path)
            return
        }
        
        for i in 0 ..< nums.count {
            if used[i] {
                continue
            }
            
            if i > 0 && nums[i-1] == nums[i] && !used[i-1] {
                continue
            }
            
            path.append(nums[i])
            used[i] = true
            backtrack(nums)
            used[i] = false
            path.removeLast()
        }
    }
}
