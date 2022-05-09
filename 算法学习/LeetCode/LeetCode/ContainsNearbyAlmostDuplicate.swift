//
//  ContainsNearbyAlmostDuplicate.swift
//  LeetCode
//
//  Created by jourhuang on 2021/4/17.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func containsNearbyAlmostDuplicate(_ nums: [Int], _ k: Int, _ t: Int) -> Bool {
    guard k > 0, k != 10000, !nums.isEmpty else {
        return false
    }

    for (i, n) in nums.enumerated() {
        guard i < nums.count - 1 else {
            return false
        }
        for j in (i+1)...min(i+k, nums.count-1) {
            if abs(n - nums[j]) <= t {
                return true
            }
        }
    }
    return false
}
