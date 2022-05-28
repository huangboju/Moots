//
//  Permute.swift
//  LeetCode
//
//  Created by jourhuang on 2021/3/29.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode.cn/problems/permutations/
class Permute {

    var result: [[Int]] = []

    func permute(_ nums: [Int]) -> [[Int]] {
        var path: [Int] = []
        var used = Array(repeating: false, count: nums.count)
        backtrack(nums, &path, &used)
        return result
    }

    func backtrack(_ nums: [Int], _ path: inout [Int], _ used: inout [Bool]) {
        if path.count == nums.count {
            result.append(path)
            return
        }

        for (i, n) in nums.enumerated() {
            if used[i] { continue }

            used[i] = true
            path.append(n)
            backtrack(nums, &path, &used)
            path.removeLast()
            used[i] = false
        }
    }
}
