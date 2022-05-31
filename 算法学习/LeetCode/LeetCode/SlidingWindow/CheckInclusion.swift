//
//  CheckInclusion.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/5/30.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

/// https://leetcode-cn.com/problems/permutation-in-string/submissions/
func checkInclusion(_ s1: String, _ s2: String) -> Bool {
    let strs = Array(s2)
    var left = 0, right = 0
    var need: [Character: Int] = [:]
    for char in s1 {
        need[char, default: 0] += 1
    }
    var window: [Character: Int] = [:]
    var matchCount = 0
    while right < strs.count {
        let char = strs[right]
        right += 1
        if need[char] != nil {
            window[char, default: 0] += 1
            if need[char] == window[char] {
                matchCount += 1
            }
        }
        
        
        while right - left >= s1.count {
            if matchCount == need.count {
                return true
            }
            
            let char = strs[left]
            left += 1
            if need[char] == nil { continue }
            if need[char] == window[char] {
                matchCount -= 1
            }
            window[char, default: 0] -= 1
        }
    }
    
    return false
}
