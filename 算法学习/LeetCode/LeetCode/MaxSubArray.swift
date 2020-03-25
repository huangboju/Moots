//
//  MaxSubArray.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2020/3/23.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

// [-2,1,-3,4,-1,2,1,-5,4]

func maxSubArray(_ nums: [Int]) -> Int {
    var result = nums[0]
    var sum = 0
    for num in nums {
        if sum > 0 {
            sum += num
        } else {
            sum = num
        }
        result = max(result, sum)
                
    }
    return result
}
