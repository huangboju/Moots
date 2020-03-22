//
//  MaxAreaOfIsland.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/21.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func maxAreaOfIsland(_ grid: [[Int]]) -> Int {
    if grid.isEmpty {
        return 0
    }
    let row = grid.count
    let col = grid[0].count
    var res = 0
    let direction = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    var visited = [[Int]](repeating: [Int](repeating: 0, count: col), count: row)
    for i in 0..<row {
        for j in 0..<col {
            if grid[i][j] == 1 {
                res = max(res, dfs(grid, &visited, direction, i, j))
            }
        }
    }
    return res
}
func dfs(_ grid: [[Int]], _ visited: inout [[Int]], _ direction: [[Int]], _ i : Int, _ j : Int) -> Int {
    visited[i][j] = 1
    var area = 1
    for k in 0..<4 {
        let newRow = i + direction[k][0]
        let newCol = j + direction[k][1]
        if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[0].count
            && grid[newRow][newCol] == 1 && visited[newRow][newCol] != 1 {
            area += dfs(grid, &visited, direction, newRow, newCol)
        }
    }
        return area
}
