//
//  main.swift
//  LeetCode
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import Foundation

// https://github.com/diwu/LeetCode-Solutions-in-Swift

print(twoSum([2, 7, 11, 15, 0, 9], 9))


print(lengthOfLongestSubstring("ppwwpwkew"))

print("\n\n")

//(0...100).forEach {
//    print($0 & 1)
//}


print(findMin(3, target: 5, arr: [1, 4, 5, 6, 7, 8]))


print("找零")
print(solve(73))



print("🍀🍀🍀🍀🍀🍀🍀🍀🍀")

// 硬币面值预先已经按降序排列
let coinValue = [25, 21, 10, 5, 1]
// 需要找零的面值
let money = 65

makeChange(coinValue, money)
