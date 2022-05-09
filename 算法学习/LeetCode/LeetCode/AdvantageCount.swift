//
//  AdvantageCount.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/3/27.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

/// https://leetcode-cn.com/problems/advantage-shuffle/
func advantageCount(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
    let count = nums2.count
    var tmpNums2: [(Int, Int)] = [] /// 位置和值
    for (i, n) in nums2.enumerated() {
        tmpNums2.append((i, n))
    }
    tmpNums2.sort { n1, n2 in
        return n1.1 > n2.1
    }
    let nums1 = nums1.sorted()
    var res = Array(repeating: 0, count: count)
    var left = 0, right = count - 1
    for (i, n) in tmpNums2 {
        if nums1[right] > n {
            res[i] = nums1[right]
            right -= 1
        } else {
            res[i] = nums1[left]
            left += 1
        }
    }
    return res
}
