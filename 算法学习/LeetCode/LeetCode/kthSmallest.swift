//
//  kthSmallest.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/6/4.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/interview/card/top-interview-quesitons-in-2018/266/heap-stack-queue/1156/

//有序矩阵中第K小的元素
//给定一个 n x n 矩阵，其中每行和每列元素均按升序排序，找到矩阵中第k小的元素。
//请注意，它是排序后的第k小元素，而不是第k个元素。
//
//示例:
//
//matrix = [
//[ 1,  5,  9],
//[10, 11, 13],
//[12, 13, 15]
//],
//k = 8,
//
//返回 13。
//说明:
//你可以假设 k 的值永远是有效的, 1 ≤ k ≤ n2 。

func kthSmallest(_ matrix: [[Int]], _ k: Int) -> Int {
    if matrix.count == 1 {
        return matrix[0][k-1]
    }
    var result = matrix[0]
    for arr in matrix.dropFirst() {
        result = mergeSortArr(result, arr)
    }
    return result[k-1]
}

func mergeSortArr(_ arr1: [Int], _ arr2: [Int]) -> [Int] {
    var result = Array(repeating: 0, count: arr1.count + arr2.count)
    var i = arr1.count - 1, j = arr2.count - 1
    result.replaceSubrange(0...i, with: arr1)
    while i >= 0 || j >= 0 {
        if j < 0 || (i >= 0 && result[i] > arr2[j]) {
            result[i + j + 1] = result[i]
            i -= 1
        } else {
            result[i + j + 1] = arr2[j]
            j -= 1
        }
    }
    return result
}
