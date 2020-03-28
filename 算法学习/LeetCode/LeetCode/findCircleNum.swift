//
//  findCircleNum.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/28.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func findCircleNum(_ M: [[Int]]) -> Int {
    var count = 0
    var visited = [Int](repeating: 0, count: M.count)
    
    for i in 0..<M.count {
        if visited[i] == 0 {
            dfs(M, &visited, i)
            count += 1
        }
    }
    return count
}

func dfs(_ M:[[Int]], _ visited: inout [Int], _ i: Int) {
    for j in 0..<M.count {
        if M[i][j] == 1 && visited[j] == 0 {
            visited[j] = 1
            dfs(M, &visited, j)
        }
    }
}
