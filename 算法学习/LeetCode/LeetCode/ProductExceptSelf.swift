//
//  ProductExceptSelf.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/4/29.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/interview/card/top-interview-quesitons-in-2018/264/array/1135/

//给定长度为 n 的整数数组 nums，其中 n > 1，返回输出数组 output ，其中 output[i] 等于 nums 中除 nums[i] 之外其余各元素的乘积。
//
//示例:
//
//输入: [1,2,3,4]
//输出: [24,12,8,6]
//说明: 请不要使用除法，且在 O(n) 时间复杂度内完成此题。

func productExceptSelf(_ nums: [Int]) -> [Int] {
    // [1,2,3,4]
    
    if nums.count <= 1 {
        return []
    }
    var res = Array(repeating: 1, count: nums.count)
    var left = 1, right = 1
    for i in 1..<nums.count {
        left *= nums[i - 1]
        right *= nums[nums.count - i]
        res[i] *= left
        res[nums.count - i - 1] *= right
    }
    return res
}


