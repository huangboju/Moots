//
//  BackPack.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2018/11/1.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import Foundation

/// 单次选择+最大体积
public func backPack1(_ m: Int, a: [Int]) -> Int {

    var result: [Int] = Array(repeating: 0, count: m + 1)
    for v in a {
        for j in 1 ... m where j >= v {
            result[j] = max(result[j-v] + v, result[j])
        }
    }
    return result[m]
}

/// 背包问题2（单次选择+装满可能性总数）
public func backPackII(_ m: Int, nums: [Int]) -> Int {
    var result: [Int] = Array(repeating: 0, count: m + 1)
    result[0] = 1
    for  n in nums {
        for j in (0 ... m).reversed() {
            if j >= n {
                print(n)
                result[j] += result[j - n]
            }
        }
    }
    return result[m]
}


/// 背包问题5（最大重量+所有可能结果）
public func backPackV(_ target: Int, nums: [Int]) -> Int {
    var result: [Int] = Array(repeating: 0, count: target + 1)
    result[0] = 1
    for j in 1 ... target {
        for  n in nums {
            if j >= n {
                result[j] += result[j - n]
            }
        }
    }
    return result[target]
}
