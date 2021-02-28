//
//  SearchInsert.swift
//  LeetCode
//
//  Created by jourhuang on 2021/2/28.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func searchInsert(_ nums: [Int], _ target: Int) -> Int {
    var start = 0
    var end = nums.count - 1
    while start <= end {
        let mid = start + (end - start) / 2
        if nums[mid] == target {
            return mid
        } else if nums[mid] > target {
            end -= 1
        } else  {
            start += 1
        }
    }
    return start
}
