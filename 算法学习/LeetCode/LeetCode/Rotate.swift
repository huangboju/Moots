//
//  Rotate.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/4/27.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

func rotate(_ nums: inout [Int], _ k: Int) {
    for _ in 0 ..< k {
        guard let n = nums.popLast() else {
            continue
        }
        nums.insert(n, at: 0)
    }
}
