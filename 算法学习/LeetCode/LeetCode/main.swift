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


print("\n🍀🍀🍀 背包问题 I 单次选择+最大体积 🍀🍀🍀")
//print(backPack1(11, a: [2, 3, 6, 7]))

print("\n🍀🍀🍀 背包问题 II 单次选择+最大价值 🍀🍀🍀")
let size = [2, 3, 5, 7]
let value = [1, 5, 2, 4]
//print(backPackII(10, size: size, value: value))

print("\n🍀🍀🍀 背包问题 III 重复选择+最大价值 🍀🍀🍀")
//print(backPackIII(10, size: size, value: value))

print("\n🍀🍀🍀 背包问题 IV 重复选择+唯一排列+装满可能性总数 🍀🍀🍀")
//print(backPackIV(7, a: [2, 3, 6, 7]))

print("\n🍀🍀🍀 背包问题 V 单次选择+装满可能性总数 🍀🍀🍀")
//print(backPackV(7, nums: [1, 2, 3, 3, 7]))

print("\n🍀🍀🍀 背包问题 VI 重复选择+唯一排列+装满可能性总数 🍀🍀🍀")
//print(backPackVI(4, nums: [1, 2, 4]))

print("\n\n\n")
print(combinationSum2([10, 2, 7, 6, 5], 11))


