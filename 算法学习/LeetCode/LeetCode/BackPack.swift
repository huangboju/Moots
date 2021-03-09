//
//  BackPack.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2018/11/1.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import Foundation

/// 单次选择+最大体积

/// Given n items with size Ai, an integer m denotes the size of a backpack. How full you can fill this  backpack?
/// Notice
/// You can not divide any item into small pieces.
/// Example
/// If we have 4 items with size [2, 3, 5, 7], the backpack size is 11, we can select [2, 3, 5], so that the  max size we can fill this backpack is 10. If the backpack size is 12. we can select [2, 3, 7] so that we can fulfill the backpack.
/// You function should return the max size we can fill in the given backpack.
/// Challenge
/// O(n x m) time and O(m) memory.
/// O(n x m) memory is also acceptable if you do not know how to optimize memory.
public func backPack1(_ m: Int, a: [Int]) -> Int {

    var result: [Int] = Array(repeating: 0, count: m + 1)
    ///1 [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    ///
    ///3 [0, 1, 1, 3, 4, 4, 4, 4, 4, 4, 4, 4]
    ///
    ///3 [0, 1, 1, 3, 4, 4, 6, 7, 7, 7, 7, 7]
    ///
    ///6 [0, 1, 1, 3, 4, 4, 6, 7, 7, 9, 10, 10]
    for v in a {
        for volume in (1 ... m).reversed() where volume >= v {
            result[volume] = max(result[volume-v] + v, result[volume])
        }
        print(v, result, "\n")
    }

    return result[m]
}






/// 单次选择+最大价值

///Given n items with size Ai and value Vi, and a backpack with size m. What's the maximum value can you put into the backpack?
///Notice
///You cannot divide item into small pieces and the total size of items you choose should smaller or equal to m.
///Example
///Given 4 items with size [2, 3, 5, 7] and value [1, 5, 2, 4], and a backpack with size 10. The maximum value is 9.
///Challenge
///O(n x m) memory is acceptable, can you do it in O(m) memory?
public func backPackII(_ m: Int, size: [Int], value: [Int]) -> Int {
    var result: [Int] = Array(repeating: 0, count: m + 1)
    for (n, value) in zip(size, value) {
        for v in (1 ... m).reversed() where v >= n {
            result[v] = max(result[v], result[v - n] + value)
        }
    }
    return result[m]
}



/// 重复选择+最大价值

///Given n kind of items with size Ai and value Vi( each item has an infinite number available) and a backpack with size m. What's the maximum value can you put into the backpack?
///Notice
///You cannot divide item into small pieces and the total size of items you choose should smaller or equal to m.
///Example
///Given 4 items with size [2, 3, 5, 7] and value [1, 5, 2, 4], and a backpack with size 10. The maximum value is 15
public func backPackIII(_ m: Int, size: [Int], value: [Int]) -> Int {
    var result: [Int] = Array(repeating: 0, count: m + 1)
    for (n, v) in zip(size, value) {
        for j in 1 ... m where j >= n {
            result[j] = max(result[j], result[j - n] + v)
        }
    }
    return result[m]
}



/// 重复选择+唯一排列+装满可能性总数

///Given n items with size nums[i] which an integer array and all positive numbers, no duplicates. An integer target denotes the size of a backpack. Find the number of possible fill the backpack.
///Each item may be chosen unlimited number of times.
///Example
///Given candidate items [2,3,6,7] and target 7,
///A solution set is:
///[7]
///[2, 2, 3]
public func backPackIV(_ m: Int, a: [Int]) -> Int {
    var result: [Int] = Array(repeating: 0, count: m + 1)
    result[0] = 1
    for n in a {
        for j in (n ... m) {
            result[j] += result[j - n]
        }
    }
    return result[m]
}

/// 单次选择+装满可能性总数

///Given n items with size nums[i] which an integer array and all positive numbers. An integer target denotes the size of a backpack. Find the number of possible fill the backpack.
///Each item may only be used once.
///Example
///Given candidate items [1,2,3,3,7] and target 7,
///A solution set is:
///[7]
///[1, 3, 3]
public func backPackV(_ m: Int, nums: [Int]) -> Int {
    var result: [Int] = Array(repeating: 0, count: m + 1)
    result[0] = 1
    for  n in nums {
        for j in (1 ... m).reversed() where j >= n {
            result[j] += result[j - n]
            print(j, result, n)
        }
        print("\n")
    }
    return result[m]
}



/// 重复选择+不同排列+装满可能性总数

///Given an integer array nums with all positive numbers and no duplicates, find the number of possible combinations that add up to a positive integer target.
///Notice
///The different sequences are counted as different combinations.
///Example
///Given nums = [1, 2, 4], target = 4
///The possible combination ways are:
///[1, 1, 1, 1]
///[1, 1, 2]
///[1, 2, 1]
///[2, 1, 1]
///[2, 2]
///[4]
public func backPackVI(_ target: Int, nums: [Int]) -> Int {
    var result: [Int] = Array(repeating: 0, count: target + 1)
    result[0] = 1
    for i in 1 ... target {
        for  n in nums where i >= n {
            result[i] += result[i - n]
        }
    }
    return result[target]
}
