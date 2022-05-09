//
//  MergeSort.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/3/9.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/featured/card/top-interview-quesitons-in-2018/261/before-you-start/1109/

//输入:
//nums1 = [1,2,3,0,0,0], m = 3
//nums2 = [2,5,6],       n = 3
//
//输出: [1,2,2,3,5,6]


func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
    var index = m+n-1
    var i = m-1
    var j = n-1
    //! 因为是把 nums2 移到 nums1，那么 j = 0 就是终止条件
    while j >= 0 {
        if i >= 0 {
            if nums2[j] >= nums1[i]  {
                nums1[index] = nums2[j]
                j -= 1
            } else {
                nums1[index] = nums1[i]
                i -= 1
            }
        } else {
            nums1[index] = nums2[j]
            j -= 1
        }
        index -= 1
    }
}

