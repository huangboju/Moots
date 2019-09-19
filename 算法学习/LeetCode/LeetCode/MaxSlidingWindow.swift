//
//  MaxSlidingWindow.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/9/17.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/interview/card/top-interview-quesitons-in-2018/266/heap-stack-queue/1158/
//输入: nums = [1,3,-1,-3,5,3,6,7], 和 k = 3
//输出: [3,3,5,5,6,7]
//解释:
//
//滑动窗口的位置                最大值
//---------------               -----
//[1  3  -1] -3  5  3  6  7       3
//1 [3  -1  -3] 5  3  6  7       3
//1  3 [-1  -3  5] 3  6  7       5
//1  3  -1 [-3  5  3] 6  7       5
//1  3  -1  -3 [5  3  6] 7       6
//1  3  -1  -3  5 [3  6  7]      7

func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
    var idx: [Int] = []
    var result: [Int] = []

    for i in 0..<nums.count {
        while let last = idx.last, nums[last] < nums[i] {
            idx.removeLast()
        }

        idx.append(i)
        
        if i >= k - 1 {
            if idx.first! + k == i {
                idx.removeFirst()
            }
            result.append(nums[idx.first!])
        }
    }
    return result
}
