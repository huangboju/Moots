//
//  NextPermutation.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2021/4/19.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/next-permutation/
// 123465
// 123564

func nextPermutation(_ nums: inout [Int]) {
    var i = nums.count - 2
    
    while i >= 0 && nums[i] >= nums[i+1] {
        i -= 1
    }
    
    if i >= 0 {
        var j = nums.count - 1
        while j >= 0 && nums[i] >= nums[j]  {
            j -= 1
        }
        nums.swapAt(i, j)
    }
    nums[i+1..<nums.count].reverse()
}
