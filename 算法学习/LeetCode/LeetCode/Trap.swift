//
//  Trap.swift
//  LeetCode
//
//  Created by jourhuang on 2021/4/24.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/trapping-rain-water/
func trap(_ height: [Int]) -> Int {
    if height.count <= 2 {
        return 0
    }
    
    var leftMax = 0
    var rightMax = 0
    var result = 0
    var left = 0, right = height.count - 1
    while left <= right {
        // 说明左墙可靠
        if leftMax <= rightMax {
            let water = leftMax - height[left]
            if water < 0 {
                leftMax = height[left]
            } else {
                result += water
            }
            left += 1
        } else {
            // 说明右墙可靠
            let water = rightMax - height[right]
            if water < 0 {
                rightMax = height[right]
            } else {
                result += water
            }
            right -= 1
        }
    }
    return result
}
