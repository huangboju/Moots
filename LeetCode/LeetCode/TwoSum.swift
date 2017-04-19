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
    
    for i in 0 ..< nums.count {
        
        let numOfFind = target - nums[i]
        
        if let numOfFindIdx = dict[numOfFind] {
            result.append(numOfFindIdx)
            result.append(i)
        } else {
            dict[nums[i]] = i
        }
    }
    
    return result
}
