//
//  IsValid.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2021/1/28.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/valid-parentheses/

func isValid(_ s: String) -> Bool {
    let map: [Character: Character] = [")": "(", "]": "[", "}": "{"]
    var lefts: [Character] = ["*"]
    for char in s {
        if map.values.contains(char) {
            lefts.append(char)
        } else if map[char] != lefts.removeLast() {
            return false
        }
    }
    return lefts.count == 1
}
