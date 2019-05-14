//
//  FindKthLargest.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/5/14.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/featured/card/top-interview-quesitons-in-2018/266/heap-stack-queue/1154/

//
//在未排序的数组中找到第 k 个最大的元素。请注意，你需要找的是数组排序后的第 k 个最大的元素，而不是第 k 个不同的元素。
//
//示例 1:
//
//输入: [3,2,1,5,6,4] 和 k = 2
//输出: 5
//示例 2:
//
//输入: [3,2,3,1,2,4,5,5,6] 和 k = 4
//输出: 4
//说明:
//
//你可以假设 k 总是有效的，且 1 ≤ k ≤ 数组的长度。

func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
    if nums.count == 1 {
        return nums[0]
    }
    var result = nums.sorted(by: >)
    return result[k - 1]
}
