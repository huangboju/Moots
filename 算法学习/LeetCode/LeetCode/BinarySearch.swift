//
//  Binary_search.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/3/27.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

/// https://labuladong.gitee.io/algo/2/19/26/
func binarySearch(_ nums: [Int], _ target: Int) -> Int {
    if nums.isEmpty {
        return -1
    }
    var left = 0
    var right = nums.count - 1
    while left <= right {
        let mid = left + (right - left) / 2
        if nums[mid] == target {
            return mid
        } else if nums[mid] > target {
            right = mid - 1
        } else {
            left = mid + 1
        }
    }
    return -1
}

func leftBound(_ nums: [Int], _ target: Int) -> Int {
    if nums.isEmpty {
        return -1
    }
    var left = 0
    var right = nums.count - 1
    while left <= right {
        let mid = left + (right - left) / 2
        if nums[mid] == target {
            right = mid - 1
        } else if nums[mid] > target {
            right = mid - 1
        } else {
            left = mid + 1
        }
    }
    if left >= nums.count || nums[left] != target {
        return -1
    }
    return left
}

func rightBound(_ nums: [Int], _ target: Int) -> Int {
    if nums.isEmpty {
        return -1
    }
    var left = 0
    var right = nums.count - 1
    while left <= right {
        let mid = left + (right - left) / 2
        if nums[mid] == target {
            left = mid + 1
        } else if nums[mid] > target {
            right = mid - 1
        } else {
            left = mid + 1
        }
    }
    if right < 0 || nums[right] != target {
        return -1
    }
    return right
}
