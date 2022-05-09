//
//  RotateImage.swift
//  LeetCode
//
//  Created by jourhuang on 2021/4/4.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/rotate-image/

//func rotateImage(_ matrix: inout [[Int]]) {
//    let n = matrix.count
//    if n <= 1 {
//        return
//    }
//    let mat = matrix
//    for i in 0..<n {
//        for j in 0..<n {
//            matrix[i][j] = mat[n-j-1][i]
//        }
//    }
//}

func rotateImage(_ matrix: inout [[Int]]) {
    let n = matrix.count
    matrix.reverse()

    for column in 0..<n {
        for row in column..<n {
            let x = matrix[row][column]
            matrix[row][column] = matrix[column][row]
            matrix[column][row] = x
        }
    }
}
