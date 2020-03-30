//
//  findLengthOfLCIS.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/29.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

//输入: [1,3,5,4,7]
//输出: 3
//解释: 最长连续递增序列是 [1,3,5], 长度为3。
//尽管 [1,3,5,7] 也是升序的子序列, 但它不是连续的，因为5和7在原数组里被4隔开。


func findLengthOfLCIS(_ nums: [Int]) -> Int {
    if nums.isEmpty { return 0 }
    var result = 0
    var tmp = 0
    for (i, n) in nums.enumerated() {
        tmp += 1
        if i + 1 == nums.count { break }
        if n >= nums[i + 1] {
            result = max(tmp, result)
            tmp = 0
        }
    }
    return max(result, tmp)
}
