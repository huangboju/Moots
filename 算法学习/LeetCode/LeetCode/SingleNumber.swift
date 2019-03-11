//
//  SingleNumber.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/3/6.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/featured/card/top-interview-quesitons-in-2018/261/before-you-start/1106/

func singleNumber(_ arr: [Int]) -> Int {
    var result = 0
    for n in arr {
        result ^= n
    }
    return result
}
