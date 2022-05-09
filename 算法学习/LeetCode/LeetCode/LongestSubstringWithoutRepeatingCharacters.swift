//
//  LongestSubstringWithoutRepeatingCharacters.swift
//  LeetCode
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/

// "ppwwpwkew"
// "abcabcbb"

func lengthOfLongestSubstring(_ s: String) -> Int {
    
    if s.isEmpty {
        return 0
    }
    
    var result = 0
    var maxLength = 0
    var dict: [String.Element: Int] = [:]
    for (i, char) in s.enumerated() {
        if let index = dict[char] {
            if i - index > maxLength {
                maxLength += 1
            } else {
                maxLength = i - index
            }
        } else {
            maxLength += 1
        }
        dict[char] = i
        result = max(maxLength, result)
    }
    return result
}
