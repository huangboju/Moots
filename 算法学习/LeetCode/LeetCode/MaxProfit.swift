//
//  MaxProfit.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2020/3/23.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation


func maxProfit(_ prices: [Int]) -> Int {
    if prices.isEmpty { return 0 }

    var minPrice = prices[0]
    var maxProfit = 0

    for price in prices {
        let profit = price - minPrice

        if profit > maxProfit {
            maxProfit = profit
        }

        minPrice = min(minPrice, price)
    }

    return maxProfit
}

func maxProfitII(_ prices: [Int]) -> Int {
    guard prices.count > 1 else { return 0 }

    var maxProfit = 0
    for i in 1 ..< prices.count {
        let profit = prices[i] - prices[i - 1]
        if profit > 0 {
            maxProfit += profit
        }
    }
    return maxProfit
}
