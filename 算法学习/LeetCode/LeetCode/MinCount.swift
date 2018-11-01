//
//  MinCount.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2018/10/22.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import Foundation

func makeChange(_ values: [Int], _ money: Int) {
    // 保存每一个面值找零所需的最小硬币数，0号单元舍弃不用，所以要多加
    var coinsUsed = [Int](repeating: 0, count: money + 1)
    var coinTrack = [Int](repeating: 0, count: money + 1)
    var last = 0
    // 对每一分钱都找零，即保存子问题的解以备用，即填表
    for cents in 1 ... money {
        // 当用最小币值的硬币找零时，所需硬币数量最多
        var minCoins = 999
        // 遍历每一种面值的硬币，看是否可作为找零的其中之一
        for (i, value) in values.enumerated() {
            // 若当前面值的硬币小于当前的cents则分解问题并查表
            if value <= cents {
                let temp = coinsUsed[cents - value] + 1
                
                if (temp < minCoins) {
                    minCoins = temp
                    last = i
                }
            }
        }
        // 保存最小硬币数
        coinsUsed[cents] = minCoins
        coinTrack[cents] = values[last]
        print("面值为 :\(cents)的最小硬币数 : \(coinsUsed[cents])")
        trackPrint(cents, coinTrack)
    }
}

func trackPrint(_ m: Int, _ coinTrack: [Int]) {
    if ( m == 0) {
        return
    } else {
        print(m, coinTrack[m])
        trackPrint(m - coinTrack[m], coinTrack)
    }
}
