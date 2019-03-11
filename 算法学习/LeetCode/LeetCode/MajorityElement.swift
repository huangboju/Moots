//
//  MajorityElement.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/3/6.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/featured/card/top-interview-quesitons-in-2018/261/before-you-start/1107/

func majorityElement(_ nums: [Int]) -> Int {
    var count = 0
    var cur = nums[0]
    for num in nums {
        if count == 0 {
            cur = num
        }
        if cur == num {
            count += 1
        } else {
            count -= 1
        }
    }
    return cur
}
