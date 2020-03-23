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

    guard s.count > 1 else { return s.count }
    let charArr: [Character] = Array(s)
    
    var maxLen = 1
    var tempLen = 1
    var hashMap = [charArr[0]: 0]

    for (i, char) in charArr.enumerated() {
        if let lastPosion = hashMap[char] {
            if tempLen < i - lastPosion { // 这种情况 "ppwwpwkew"
                tempLen += 1
            } else {
                tempLen = i - lastPosion
            }
        } else {
            tempLen += 1
        }

        hashMap[char] = i

        maxLen = max(tempLen, maxLen)
    }

    return maxLen
}
