//
//  LongestSubstringWithoutRepeatingCharacters.swift
//  LeetCode
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import Foundation

private extension String {
    /*
     Ref: http://oleb.net/blog/2014/07/swift-strings/
     "Because of the way Swift strings are stored, the String type does not support random access to its Characters via an integer index — there is no direct equivalent to NSStringʼs characterAtIndex: method. Conceptually, a String can be seen as a doubly linked list of characters rather than an array."
     
     By creating and storing a seperate array of the same sequence of characters,
     we could hopefully achieve amortized O(1) time for random access.
     */
    func randomAccessCharactersArray() -> [Character] {
        return Array(self.characters)
    }
}
// "ppwwpwkew"

func lengthOfLongestSubstring(_ s: String) -> Int {
    let charArr = s.randomAccessCharactersArray()
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
