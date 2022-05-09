//
//  MaxArea.swift
//  LeetCode
//
//  Created by jourhuang on 2021/1/9.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func maxArea(_ height: [Int]) -> Int {
    var left = 0
    var right = height.count - 1
    var maxArea = (right - left) * min(height[left], height[right])
    while left < right {
        if height[left] > height[right] {
            right -= 1
        } else {
            left += 1
        }
        maxArea = max(maxArea, (right - left) * min(height[left], height[right]))
    }
    return maxArea
}
