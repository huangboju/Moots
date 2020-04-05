//
//  MaxAreaOfIsland.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/21.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func maxAreaOfIsland(_ grid: [[Int]]) -> Int {
    if grid.isEmpty { return 0 }
    let row = grid.count
    let col = grid[0].count
    var res = 0
    let direction = [(1, 0), (-1, 0), (0, 1), (0, -1)]
    var visited = [[Int]](repeating: [Int](repeating: 0, count: col), count: row)
    for x in 0..<row {
        for y in 0..<col {
            if grid[x][y] == 1 {
                res = max(res, dfs(grid, &visited, direction, x, y))
            }
        }
    }
    return res
}
func dfs(_ grid: [[Int]], _ visited: inout [[Int]], _ direction: [(Int, Int)], _ x : Int, _ y : Int) -> Int {
    visited[x][y] = 1
    var area = 1
    for k in 0..<4 {
        let dx = x + direction[k].0
        let dy = y + direction[k].1
        if 0..<grid.count ~= dx, 0..<grid[0].count ~= dy, grid[dx][dy] == 1, visited[dx][dy] != 1 {
            area += dfs(grid, &visited, direction, dx, dy)
        }
    }
    return area
}
