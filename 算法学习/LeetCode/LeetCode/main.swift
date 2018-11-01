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

print(bubbleSort([2, 7, 11, 15, 0, 9]))
//(0...100).forEach {
//    print($0 & 1)
//}



print("🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀")

// 硬币面值预先已经按降序排列
let coinValue = [100, 50, 20, 10, 5, 1]
// 需要找零的面值
let money = 165

makeChange(coinValue, money)


/*
 let n = [1, 4, 7, 9, 2, 31, 21, 13, 12, 6, 8, 9]
 
 target = 32
 
 input:
 [
 [1, 4, 7, 9, 2, 8],
 [31],
 [21, 9],
 [13, 12, 6]
 ]
 */

var n = [0,1,0,3,12]

moveZeroes(&n)
print(n)


print("🍀🍀🍀 背包问题 1 🍀🍀🍀")

print(backPack1(11, a: [2,3,5,7]))

