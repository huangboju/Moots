//
//  Subsets.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/5/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode.cn/problems/subsets/
// https://labuladong.github.io/algo/1/8/
class SubsetsSolution {
    var result: [[Int]] = []
    var path: [Int] = []

    func subsets(_ nums: [Int]) -> [[Int]] {
        backtrack(nums, 0)
        return result
    }

    func backtrack(_ nums: [Int], _ start: Int) {
        result.append(path)

        for i in start ..< nums.count {
            path.append(nums[i])
            backtrack(nums, i + 1)
            path.removeLast()
        }
    }
}

// https://leetcode.cn/problems/subsets-ii/
class SubsetsWithDupSolution {

    var result: [[Int]] = []
    var path: [Int] = []
    
    func subsetsWithDup(_ nums: [Int]) -> [[Int]] {
        backtrack(nums.sorted(), 0)
        return result
    }
    
    func backtrack(_ nums: [Int], _ start: Int) {
        result.append(path)
        
        for i in start ..< nums.count {
            
            if i > start && nums[i] == nums[i - 1] { continue }

            path.append(nums[i])
            backtrack(nums, i+1)
            path.removeLast()
        }
    }
}
