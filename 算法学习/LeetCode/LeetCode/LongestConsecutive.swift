//
//  LongestConsecutive.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/4/6.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func longestConsecutive(_ nums: [Int]) -> Int {
    var numSet = Set(nums)
    var longest = 0
    for num in nums {
        if numSet.contains(num) {
            var left = num - 1
            var right = num + 1
            numSet.remove(num)
            while numSet.contains(left) {
                numSet.remove(left)
                left -= 1
            }
            while numSet.contains(right) {
                numSet.remove(right)
                right += 1
            }
            longest = max(longest, right - left - 1)
        }
    }
    return longest
}
