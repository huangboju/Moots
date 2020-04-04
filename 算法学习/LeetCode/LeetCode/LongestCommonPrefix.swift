//
//  LongestCommonPrefix.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/4/4.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func longestCommonPrefix(_ strs: [String]) -> String {
    if strs.isEmpty { return "" }
    let count = strs.count
    if count == 1 { return strs.first! }
    
    var result = strs[0]

    for i in 1..<count {
        while !strs[i].hasPrefix(result) {
            result = String(result.prefix(result.count - 1))
            if result.count == 0 { return "" }
        }
    }
    return result
}
