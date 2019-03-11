//
//  MergeSort.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/3/9.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation


func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
    var i = m - 1, j = n - 1
    while i >= 0 || j >= 0 {
        if j < 0 || (i >= 0 && nums1[i] > nums2[j]) {
            nums1[i + j + 1] = nums1[i]
            i -= 1
        } else {
            nums1[i + j + 1] = nums2[j]
            j -= 1
        }
    }
}

