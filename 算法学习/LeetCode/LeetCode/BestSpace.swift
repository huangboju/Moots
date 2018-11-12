//
//  BestSpace.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2018/10/15.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import Foundation

//func bestSpace(_ a: [Int], target: Int) -> [Int] {
//    
//}

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

