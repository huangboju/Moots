//
//  Permute.swift
//  LeetCode
//
//  Created by jourhuang on 2021/3/29.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func permute(_ nums: [Int]) -> [[Int]] {
    guard !nums.isEmpty else {
        return []
    }
    
    let n = nums.count
    if n == 1 {
        return [nums]
    }
    
    var used = Array(repeating: false, count: n)
    var res: [[Int]] = []
    var ans: [Int] = []
    backtrack(nums, &used, &ans, &res)
    return res
}

// https://labuladong.gitbook.io/algo/bi-du-wen-zhang/hui-su-suan-fa-xiang-jie-xiu-ding-ban
func backtrack(_ nums: [Int], _ used: inout [Bool], _ ans: inout [Int], _ res: inout [[Int]]) {
    if ans.count == nums.count {
        res.append(ans)
        return
    }
    
    for i in 0..<nums.count {
        if used[i] {
            continue
        }
        used[i] = true
        ans.append(nums[i])
        backtrack(nums, &used, &ans, &res)
        ans.removeLast()
        used[i] = false
    }
}
