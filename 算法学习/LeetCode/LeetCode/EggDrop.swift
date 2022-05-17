//
//  EggDrop.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/3/23.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode.cn/problems/super-egg-drop/
func superEggDrop(_ K: Int, _ N: Int) -> Int {
    
    // 换个思路，需要扔多少个鸡蛋可以覆盖N层楼
    var result: [Int] = Array(repeating: 0, count: K + 1)
    var m = 0
    
    while result[K] < N {
        m += 1
        for k in (1 ... K).reversed() {
            result[k] += result[k - 1] + 1
        }
    }
    return m
}

