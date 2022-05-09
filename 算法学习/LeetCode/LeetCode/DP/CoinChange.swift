//
//  CoinChange.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/2/20.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

// 322. 零钱兑换
// https://leetcode-cn.com/problems/coin-change/submissions/
func coinChange(_ coins: [Int], _ amount: Int) -> Int {
    var dp = [Int](repeating: amount + 1, count: amount + 1)
    dp[0] = 0
    for i in 0 ..< dp.count {
        for coin in coins {
            if i - coin < 0 {
                continue
            }
            dp[i] = min(dp[i], dp[i - coin] + 1)
        }
    }
    return dp[amount] == amount + 1 ? -1 : dp[amount]
}
