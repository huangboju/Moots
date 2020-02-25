//
//  SearchMatrix.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/3/6.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/featured/card/top-interview-quesitons-in-2018/264/array/1134/

//[
//  [1,   4,  7, 11, 15],
//  [2,   5,  8, 12, 19],
//  [3,   6,  9, 16, 22],
//  [10, 13, 14, 17, 24],
//  [18, 21, 23, 26, 30]
//]

func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
    if matrix.isEmpty || matrix[0].isEmpty {
        return false
    }
    
    var row = matrix.count - 1, col = 0
    
    while row >= 0 && col < matrix[0].count {
        if matrix[row][col] < target {
            col += 1
        } else if matrix[row][col] > target {
            row -= 1
        } else {
            return true
        }
    }
    
    return false
}
