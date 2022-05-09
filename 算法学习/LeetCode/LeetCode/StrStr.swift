//
//  StrStr.swift
//  LeetCode
//
//  Created by jourhuang on 2021/2/22.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/implement-strstr/submissions/

func strStr(_ haystack: String, _ needle: String) -> Int {
    if haystack == needle {
        return 0
    }
    
    if haystack.count < needle.count {
        return -1
    }
    
    var s = haystack
    for i in 0...(s.count - needle.count) {
        if s.hasPrefix(needle) {
            return i
        }
        s.remove(at: s.startIndex)
    }
    return -1
}

