//
//  RemoveElement.swift
//  LeetCode
//
//  Created by jourhuang on 2021/2/22.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/remove-element/submissions/

func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
    var slowIndex = 0
    for n in nums {
        if val != n {
            nums[slowIndex] = n
            slowIndex += 1
        }
    }
    return slowIndex
}
