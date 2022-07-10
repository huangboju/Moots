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
    for coin in coins {
        for i in 0 ... amount {
            if coin > i { continue }
            dp[i] = min(dp[i], dp[i - coin] + 1)
        }
    }
    return dp[amount] == amount + 1 ? -1 : dp[amount]
}

// https://leetcode.cn/problems/coin-change-2/
// https://leetcode.cn/problems/coin-change-2/solution/ling-qian-dui-huan-iihe-pa-lou-ti-wen-ti-dao-di-yo/
func change(_ amount: Int, _ coins: [Int]) -> Int {
    if amount == 0 {
        return 1
    }
    var dp = Array(repeating: 0, count: amount + 1)
    dp[0] = 1
    for coin in coins {
        for j in 1 ... amount {
            if coin > j { continue }
            dp[j] += dp[j-coin]
        }
    }
    return dp[amount]
}
