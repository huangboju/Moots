//
//  findMedianSortedArrays.swift
//  LeetCode
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

// https://leetcode-cn.com/problems/median-of-two-sorted-arrays/

//nums1 = [1,3], nums2 = [2]

func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
    var index1 = 0
    var index2 = 0
    var pre = 0
    var current = 0
    
    while index1 + index2 <= (nums1.count + nums2.count) / 2 {
        pre = current

        if index2 >= nums2.count || (index1 < nums1.count && nums1[index1] < nums2[index2]) {
            current = nums1[index1]
            index1 += 1
        } else {
            current = nums2[index2]
            index2 += 1
        }
    }

    if (nums1.count + nums2.count) % 2 == 0 {
        return Double(current + pre) / 2
    } else {
        return Double(current)
    }
}
