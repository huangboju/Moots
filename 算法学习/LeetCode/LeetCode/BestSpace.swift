//
//  BestSpace.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2018/10/15.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import Foundation

/*
    let n = [1, 4, 7, 9, 2, 31, 21, 13, 12, 6, 8, 9]
 
    target = 32
 
    input:
    [
        [1, 4, 7, 9, 2, 8],
        [31],
        [21, 9],
        [13, 12, 6]
    ]
 */

func bestSpace(_ a: [Int], target: Int) -> [[Int]] {
    var temp = a[0]
    var reuslt: [[Int]] = [[temp]]
    var row = 0
    for (i, n) in a.dropFirst().enumerated() {
        if temp < target {
            temp += n
            reuslt[row].append(n)
        } else if temp == target {
            temp = 0
            row += 1
        } else {
            temp -= n
            let total = reuslt[row].reduce(0, +)
        }
    }

    return reuslt
}

func findMin(_ total: Int, target: Int, arr: [Int]) -> Int {
    if total >= target { return total }

    var result = -1
    var min = Int.max
    for item in arr {
        let n = target - total - item
        if n >= 0 {
            if min > n {
                min = n
                result = item
            }
        }
    }
    return result
}
