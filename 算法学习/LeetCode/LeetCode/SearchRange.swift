//
//  SearchRange.swift
//  LeetCode
//
//  Created by jourhuang on 2021/2/25.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
    var result = [-1, -1]
    if nums.isEmpty {
        return result
    }
    var start = 0
    var end = nums.count - 1
    while start <= end {
        let mid = start + (end - start) / 2
        if nums[mid] == target {
//            var left =
        } else if nums[mid] > target {
            end -= 1
        } else {
            start -= 1
        }
    }
    return result
}
