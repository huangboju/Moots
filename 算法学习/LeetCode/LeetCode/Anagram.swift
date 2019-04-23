//
//  Anagram.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/4/23.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/featured/card/top-interview-quesitons-in-2018/275/string/1142/

func isAnagram(_ s: String, _ t: String) -> Bool {
    let chars_S = s.unicodeScalars
    var counter_S = Array(repeating: 0, count: 26)
    let chars_T = t.unicodeScalars
    var counter_T = Array(repeating: 0, count: 26)
    
    for char in chars_S {
        let index = Int(char.value - 97)
        counter_S[index] += 1
    }
    
    for char in chars_T {
        let index = Int(char.value - 97)
        counter_T[index] += 1
    }
    return counter_T == counter_S
}
