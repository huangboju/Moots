//
//  MaxProduct.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/4/23.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/interview/card/top-interview-quesitons-in-2018/264/array/1126/
//输入: [2,3,-2,4]
//输出: 6
//解释: 子数组 [2,3] 有最大乘积 6。

//输入: [-2,0,-1]
//输出: 0
//解释: 结果不能为 2, 因为 [-2,-1] 不是子数组
func maxProduct(_ nums: [Int]) -> Int {
    // write your code here
    typealias SubArrayProduct = (min:Int, max:Int)
    var result = nums[0]
    var products: SubArrayProduct = (nums[0], nums[0])
    for i in 1 ..< nums.count {
        let p1 = nums[i] * products.max
        let p2 = nums[i] * products.min
        products.max = max(max(p1, p2), nums[i])
        products.min = min(min(p1, p2), nums[i])
        if products.max > result {
            result = products.max
        }
    }
    return result
}
