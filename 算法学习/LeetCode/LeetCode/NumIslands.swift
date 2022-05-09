//
//  NumIslands.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/3/5.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation


// https://leetcode-cn.com/problems/number-of-islands/comments/
class NumIslands {
    func numIslands(_ grid: [[Character]]) -> Int {
        var grid = grid
        let row = grid.count, col = grid[0].count
        var result = 0
        for i in 0 ..< row {
            for j in 0 ..< col {
                if grid[i][j] == "1" {
                    result += 1
                }
                dfs(&grid, i, j)
            }
        }
        return result
    }
    
    func dfs(_ grid: inout [[Character]], _ i: Int, _ j: Int) {
        let row = grid.count, col = grid[0].count
        if i < 0 || j < 0 || i >= row || j >= col {
            return
        }
        if grid[i][j] == "0" {
            return
        }
        grid[i][j] = "0"
        dfs(&grid, i, j+1)
        dfs(&grid, i, j-1)
        dfs(&grid, i-1, j)
        dfs(&grid, i+1, j)
    }
}
