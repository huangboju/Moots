//
//  SpiralOrder.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/30.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

//[
// [ 1, 2, 3 ],
// [ 4, 5, 6 ],
// [ 7, 8, 9 ]
//]

func spiralOrder(_ matrix: [[Int]]) -> [Int] {
    var result = [Int]()
    var x = 0
    var y = -1
    var rows = matrix[0].count + 1
    var cols = matrix.count
    var count = 0
    while result.count < matrix.count * matrix[0].count {
        rows -= 1
        for _ in 0..<rows {
            count % 2 == 0 ? (y += 1) : (y -= 1)
            result.append(matrix[x][y])
        }
        cols -= 1
        for _ in 0..<cols {
            count % 2 == 0 ? (x += 1) : (x -= 1)
            result.append(matrix[x][y])
        }
        count += 1
    }
    return result
}
