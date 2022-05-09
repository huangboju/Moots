//
//  Intersect.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/5/6.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/intersection-of-two-arrays-ii/

//输入: nums1 = [1,2,2,1], nums2 = [2,2]
//输出: [2,2]
//示例 2:
//
//输入: nums1 = [4,9,5], nums2 = [9,4,9,8,4]
//输出: [4,9]

func intersect(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
    var hs = [Int: Int](), res = [Int]()
    for num in nums1 {
        hs[num, default: 0] += 1
    }
    for num in nums2 {
        if let record = hs[num], record > 0 {
            res.append(num)
            hs[num] = record - 1
        }
    }
    return res
}
