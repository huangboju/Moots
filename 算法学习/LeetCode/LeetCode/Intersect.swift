//
//  Intersect.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/5/6.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/featured/card/top-interview-quesitons-in-2018/264/array/1132/

//输入: nums1 = [1,2,2,1], nums2 = [2,2]
//输出: [2,2]
//示例 2:
//
//输入: nums1 = [4,9,5], nums2 = [9,4,9,8,4]
//输出: [4,9]

func intersect(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
    let large: [Int]
    let small: [Int]
    if nums1.count > nums2.count {
        large = nums1
        small = nums2
    } else {
        large = nums2
        small = nums1
    }
    var result: [Int] = []
    var start = 0
    for n in large {
        if n == small[start] {
            result.append(n)
            start += 1
        }
    }
    
    
    return result
}
