//
//  GenerateParenthesis.swift
//  LeetCode
//
//  Created by jourhuang on 2021/2/21.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/generate-parentheses/
func generateParenthesis(_ n: Int) -> [String] {
    var dp: [[String]] = Array(repeating: [], count: n + 1)
    // 初始化dp[0]
    dp[0] = [""]
    // 计算dp[i]
    for i in 1 ..< n + 1 {
        for p in 0 ..< i {
            // 得到dp[p]的所有有效组合
            let l1 = dp[p]
            // 得到dp[q]的所有有效组合
            let l2 = dp[i-1-p]
            for k1 in l1 {
                for k2 in l2 {
                    dp[i].append("(\(k1))\(k2)")
                }
            }
        }
    }
    return dp[n]
}
