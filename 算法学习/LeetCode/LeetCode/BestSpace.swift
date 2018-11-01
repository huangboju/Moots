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
    var result: [Int] = []
    var sum = a[0]
    for (i, n) in a.dropFirst().enumerated() {
        let value = 10 + n
        sum += value
        if sum > target {
            sum -= value
            for m in i + 1 ..< a.count {
                
            }
        } else {
            result.append(n)
        }
    }
    
    return result
}

func moveZeroes(_ nums: inout [Int]) {
    var fast = 0
    var slow = 0
    let n = nums.count
    
    while fast < n {
        if nums[fast] != 0 {
            nums[slow] = nums[fast]
            slow += 1
        }
        fast += 1
    }
    for i in slow ..< n {
        nums[i] = 0
    }
}

