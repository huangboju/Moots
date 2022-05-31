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

//
//func slidingWindow(_ s: String, _ t: String) {
//    var need: [Character: Int] = [:]
//    var window: [Character: Int] = [:]
//    for char in s {
//        need[char, default: 0] += 1
//    }
//    var left = 0, right = 0
//    var valid = 0
//    while right < s.count {
//        // c 是将移入窗口的字符
//        let c = s[right]
//        // 右移（增大）窗口
//        right += 1
//        // 进行窗口内数据的一系列更新
//        // 填充代码
//
//        /*** debug 输出的位置 ***/
//        print("window: [%d, %d)\n", left, right)
//        /********************/
//
//        // 判断左侧窗口是否要收缩
//        while window needs shrink {
//            // d 是将移出窗口的字符
//            let d = s[left]
//            // 左移（缩小）窗口
//            left += 1
//            // 进行窗口内数据的一系列更新
//            // 填充代码
//        }
//    }
//}

