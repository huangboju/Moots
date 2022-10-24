//
//  TwoSum.swift
//  LeetCode
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import Foundation

//Given nums = [2, 7, 11, 15], target = 9,
//
//Because nums[0] + nums[1] = 2 + 7 = 9,
//return [0, 1].

func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    
    var dict = [Int: Int]()
    var result = [Int]()
    
    for (i, n) in nums.enumerated() {
        
        let numOfFind = target - n
        
        if let numOfFindIdx = dict[numOfFind] {
            result.append(numOfFindIdx)
            result.append(i)
        } else {
            dict[n] = i
        }
    }
    
    return result
}

// https://leetcode.cn/problems/two-sum-ii-input-array-is-sorted/
class TwoSum {
    func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
        var left = 0, right = numbers.count - 1
        while left < right {
            let sum = numbers[left] + numbers[right]
            if sum == target {
                return [left+1, right+1]
            } else if sum > target {
                right -= 1
            } else {
                left += 1
            }
        }
        return [-1, -1]
    }
}
