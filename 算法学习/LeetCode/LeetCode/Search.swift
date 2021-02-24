//
//  Search.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/28.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

// nums = [4,5,6,7,0,1,2], target = 0
func search(_ nums: [Int], _ target: Int) -> Int {
    if nums.isEmpty { return -1 }
    var start = 0
    var end = nums.count - 1
    while start <= end {
        let mid = start + (end - start) / 2
        if nums[mid] == target { return mid }
        if nums[start] <= nums[mid] {
            if target >= nums[start] && target < nums[mid] {
                end = mid - 1
            } else {
                start = mid + 1
            }
        } else {
            if target > nums[mid] && target <= nums[end] {
                start = mid + 1
            } else {
                end = mid - 1
            }
        }
    }
    return -1
}

func _search(_ nums: [Int], target: Int) -> Int {
    if nums.isEmpty { return -1 }
    var start = 0
    var end = nums.count - 1
    var mid = 0
    
    while start <= end {
        mid = start + (end - start) / 2
        if nums[mid] == target { return mid }
        if nums[start] <= target {
            if nums[start] == target { return start }
            if target > nums[start] && target < nums[mid] {
                end = mid - 1
            } else {
                start = mid + 1
            }
        } else {
            if nums[end] == target { return start }
            if target > nums[mid] && target < nums[end] {
                start = mid + 1
            } else {
                end = mid - 1
            }
        }
    }
    
    return -1
}
