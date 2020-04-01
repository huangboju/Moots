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
    var res = [Int]()
    if matrix.isEmpty { return res }
    var startX = 0
    var endX = matrix.count - 1
    var startY = 0
    var endY = matrix[0].count - 1
    
    while true {
        for i in startY...endY {
            res.append(matrix[startX][i])
        }
        startX += 1
        if startX > endX { break }
        
        for i in startX...endX {
            res.append(matrix[i][endY])
        }
        endY -= 1
        if startY > endY { break }


        for i in stride(from: endY, through:startY, by:-1) {
            res.append(matrix[endX][i])
        }
        endX -= 1
        
        if startX > endX { break }
        for i in stride(from:endX, through:startX, by:-1) {
            res.append(matrix[i][startY])
        }

        startY += 1
        if startY > endY { break }
    }
    return res
}
