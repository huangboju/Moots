//
//  main.swift
//  TowSum
//
//  Created by 伯驹 黄 on 2017/2/4.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import Foundation

//Given nums = [2, 7, 11, 15], target = 9,
//
//Because nums[0] + nums[1] = 2 + 7 = 9,
//return [0, 1].

func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var hashMap = [Int: Int]()
    var result = [Int]()
    for i in 0..<nums.count {
        let numberToFind = target - nums[i]
        if let numberToFindIndex = hashMap[numberToFind] {
            result.append(numberToFindIndex)
            result.append(i)
        } else {
            hashMap[nums[i]] = i
        }
    }
    return result
}

print(twoSum([2, 7, 11, 15, 0, 9], 9))

var arr = Array(repeating: 2, count: 1000000000)

func removeValue(_ nums: [Int], _ target: Int) -> Int {
    var count = 0
    for n in nums {
        if n == target {
            count += 1
        }
    }
    
    return nums.count - count
}


















