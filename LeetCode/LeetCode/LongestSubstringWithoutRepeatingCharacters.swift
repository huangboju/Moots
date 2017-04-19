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

func lengthOfLongestSubstring(_ s: String) -> Int {
    let charArr = s.randomAccessCharactersArray()
    let len = charArr.count
    if len <= 1 {
        return len
    } else {
        var tmpMaxLen = 1
        var maxLen = 1
        var hashMap = Dictionary<Character, Int>()
        hashMap[charArr[0]] = 0
        for i in 1 ..< len {
            if let lastPosition = hashMap[charArr[i]] {
                if lastPosition < i - tmpMaxLen {
                    tmpMaxLen += 1
                } else {
                    tmpMaxLen = i - lastPosition
                }
            } else {
                tmpMaxLen += 1
            }
            hashMap[charArr[i]] = i
            if tmpMaxLen > maxLen {
                maxLen = tmpMaxLen
            }
        }
        return maxLen
    }
}
