//
//  IncreasingTriplet.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/5/1.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/interview/card/top-interview-quesitons-in-2018/264/array/1133/

func increasingTriplet(_ nums: [Int]) -> Bool {
    var min = Int.max
    var second_min = Int.max
    for num in nums {
        if num <= min {
            min = num
        } else if num <= second_min {
            second_min = num
        } else {
            return true
        }
    }
    return false
}
