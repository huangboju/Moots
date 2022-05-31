//
//  MinWindow.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/5/30.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

/// https://leetcode-cn.com/problems/minimum-window-substring/
func minWindow(_ s: String, _ t: String) -> String {
    let strs = Array(s)
    var need: [Character: Int] = [:]
    var window: [Character: Int] = [:]
    for c in t {
        need[c, default: 0] += 1
    }
    var left = 0, right = 0
    var start = 0, end = 0
    var matchCount = 0
    var minLength = Int.max
    while right < strs.count {
        let char = strs[right]
        right += 1
        if need[char] == nil { continue }
        window[char, default: 0] += 1
        if window[char] == need[char] {
            matchCount += 1
        }
        
        while matchCount == need.count {
            if right - left < minLength {
                start = left
                end = right
                minLength = right - left
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
    
    return minLength == Int.max ? "" : String(strs[start..<end])
}

