//
//  RemoveDuplicates.swift
//  LeetCode
//
//  Created by jourhuang on 2021/2/21.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func removeDuplicates(_ nums: inout [Int]) -> Int {
    // [0,0,1,1,1,2,2,3,3,4]
    if nums.count <= 1 {
        return nums.count
    }
    
    var newIndex = 1
    for i in 1 ..< nums.count {
        if nums[i] != nums[i - 1] {
            nums[newIndex] = nums[i]
            newIndex += 1
        }
    }
    return newIndex
}

