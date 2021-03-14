//
//  IsPalindrome.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/3/22.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/valid-palindrome/?utm_source=LCUS&utm_medium=ip_redirect&utm_campaign=transfer2china
func isPalindrome(_ s: String) -> Bool {
    var result = ""
    for c in s.lowercased() {
        if "0"..."9" ~= c || "A"..."Z" ~= c || "a"..."z" ~= c {
            result.append(c)
        }
    }
    return result == String(result.reversed())
}
