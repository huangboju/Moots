//
//  NumArray.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/5/7.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/range-sum-query-immutable/
// https://labuladong.github.io/algo/2/18/21/
class NumArray {

    var preSum: [Int] = []

    init(_ nums: [Int]) {
        print(nums)
        preSum = Array(repeating: 0, count: nums.count + 1)
        for i in 0 ..< nums.count  {
            preSum[i + 1] = preSum[i] + nums[i]
        }
    }
    
    func sumRange(_ left: Int, _ right: Int) -> Int {
        return preSum[right + 1] - preSum[left]
    }
}

class NumMatrix {
    
    var preSum: [[Int]] = []
    
    init(_ matrix: [[Int]]) {
        if matrix.isEmpty { return }
        let row = matrix.count
        let col = matrix[0].count
        preSum = Array(repeating: Array(repeating: 0, count: col + 1), count: row + 1)
        for i in 1 ... row {
            for j in 1 ... col {
                preSum[i][j] = preSum[i][j - 1] + preSum[i - 1][j] - preSum[i - 1][j - 1] + matrix[i - 1][j - 1]
            }
        }
    }
    
    func sumRegion(_ row1: Int, _ col1: Int, _ row2: Int, _ col2: Int) -> Int {
        preSum[row2 + 1][col2 + 1] - preSum[row2 + 1][col1] - preSum[row1][col2 + 1] + preSum[row1][col1]
    }
}
