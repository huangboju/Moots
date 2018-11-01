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

func bestSpace(_ a: [Int], target: Int) -> [Int] {
    let interval = 1
    var temp = a[0] + interval
    var reuslt = [temp]
    var row = 0
    for (i, n) in a.dropFirst().enumerated() {
        if temp > target {
            temp -= n
        } else {
            temp += (n + interval)
            reuslt.append(n)
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
