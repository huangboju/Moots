//
//  BackPack.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2018/11/1.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import Foundation

public func backPack1(_ m: Int, a: [Int]) -> Int {
    var result: [Int] = Array(repeating: 0, count: m + 1)

    for v in a {
        for j in 1 ... m {
            if j >= v {
                result[j] = max(result[j], result[j-v] + v)
            }
        }
    }
    print(result)
    return result[m]
}
