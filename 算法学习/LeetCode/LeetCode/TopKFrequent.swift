//
//  TopKFrequent.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/9/16.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation


//输入: nums = [1,1,1,2,2,3], k = 2
//输出: [1,2]

func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
    var counter: [Int: Int] = [:]
    
    for n in nums {
        if let v = counter[n] {
            counter[n] = v + 1
        } else {
            counter[n] = 1
        }
    }
    let sorted = counter.sorted { $0.value > $1.value }
    var result: [Int] = []
    for i in 0 ..< k {
        result.append(sorted[i].key)
    }
    return result
}
