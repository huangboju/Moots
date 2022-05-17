//
//  MinPathSum.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/5/16.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

class MinPathSum {
    func minPathSum(_ grid: [[Int]]) -> Int {
        let m = grid.count
        let n = grid[0].count
        var memo = Array(repeating: Array(repeating: 0, count: n), count: m)
        memo[0][0] = grid[0][0]
        for i in 1 ..< m {
            memo[i][0] = memo[i - 1][0] + grid[i][0]
        }
        for j in 1 ..< n {
            memo[0][j] = memo[0][j - 1] + grid[0][j]
        }
        for i in 1 ..< m {
            for j in 1 ..< n {
                memo[i][j] = min(memo[i-1][j], memo[i][j-1]) + grid[i][j]
            }
        }
        return memo[m-1][n-1]
    }
}
