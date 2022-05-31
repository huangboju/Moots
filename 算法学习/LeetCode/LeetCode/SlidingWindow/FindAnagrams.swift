//
//  FindAnagrams.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/5/30.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

/// https://leetcode-cn.com/problems/find-all-anagrams-in-a-string/submissions/
func findAnagrams(_ s: String, _ p: String) -> [Int] {
    var left = 0, right = 0
    var matchCount = 0
    var window: [Character: Int] = [:]
    var need: [Character: Int] = [:]
    let strs = Array(s)
    var result: [Int] = []
    for char in p {
        need[char, default: 0] += 1
    }
    
    while right < strs.count {
        let char = strs[right]
        right += 1
        if need[char] != nil {
            window[char, default: 0] += 1
            if need[char] == window[char] {
                matchCount += 1
            }
        }
        
        while right - left >= p.count {
            if matchCount == need.count {
                result.append(left)
            }
            let char = strs[left]
            left += 1
            if need[char] != nil {
                if need[char] == window[char] {
                    matchCount -= 1
                }
                window[char, default: 0] -= 1
            }
        }
    }
    return result
}
