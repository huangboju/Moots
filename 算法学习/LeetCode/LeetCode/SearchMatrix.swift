//
//  SearchMatrix.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/3/6.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

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
