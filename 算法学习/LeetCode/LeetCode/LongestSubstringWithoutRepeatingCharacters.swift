//
//  LongestSubstringWithoutRepeatingCharacters.swift
//  LeetCode
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import Foundation

// "ppwwpwkew"
// "abcabcbb"

func lengthOfLongestSubstring(_ s: String) -> Int {
    
    let charArr: [Character] = Array(s)
    let len = charArr.count
    guard len > 1 else { return len }
    
    var maxLen = 1
    var tempLen = 1
    var hashMap = [charArr[0]: 0]
    
    for i in 1 ..< len {
        if let lastPosion = hashMap[charArr[i]] {
            if tempLen < i - lastPosion { // 这种情况 "ppwwpwkew"
                tempLen += 1
            } else {
                tempLen = i - lastPosion
            }
        } else {
            tempLen += 1
        }

        hashMap[charArr[i]] = i

        if tempLen > maxLen {
            maxLen = tempLen
        }
    }

    return maxLen
}
