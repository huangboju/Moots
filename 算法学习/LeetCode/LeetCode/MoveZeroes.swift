//
//  BestSpace.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2018/10/15.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import Foundation

//var n = [0,1,0,3,12]

func moveZeroes(_ nums: inout [Int]) {
    var slow = 0

    for n in nums {
        if n != 0 {
            nums[slow] = n
            slow += 1
        }
    }
    for i in slow ..< nums.count {
        nums[i] = 0
    }
}

