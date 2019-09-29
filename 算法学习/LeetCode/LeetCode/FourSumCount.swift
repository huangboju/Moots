//
//  FourSumCount.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/9/29.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

func fourSumCount(_ A: [Int], _ B: [Int], _ C: [Int], _ D: [Int]) -> Int {
    var map: [Int: Int] = [:]
    for a in A {
        for b in B {
            let sum = a + b
            map[sum, default: 0] += 1
        }
    }
    
    var count = 0
    for c in C {
        for d in D {
            let sum = c + d
            if let negativeOfSum = map[-sum] {
                count += negativeOfSum
            }
        }
    }
    
    return count
}
