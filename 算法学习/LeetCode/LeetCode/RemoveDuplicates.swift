//
//  RemoveDuplicates.swift
//  LeetCode
//
//  Created by jourhuang on 2021/2/21.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode.cn/problems/remove-duplicates-from-sorted-array/
func removeDuplicates(_ nums: inout [Int]) -> Int {
    // [0,0,1,1,1,2,2,3,3,4]
    if nums.count <= 1 {
        return nums.count
    }
    var fast = 0, slow = 0
    while fast < nums.count {
        if nums[fast] != nums[slow] {
            slow += 1
            nums[slow] = nums[fast]
        }
        fast += 1
    }
    return slow + 1
}

