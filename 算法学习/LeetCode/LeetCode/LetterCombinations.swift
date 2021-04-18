//
//  LetterCombinations.swift
//  LeetCode
//
//  Created by jourhuang on 2021/1/10.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/letter-combinations-of-a-phone-number/
func letterCombinations(_ digits: String) -> [String] {

    if digits.isEmpty { return [] }
    
    let lettersArray: [[String]] = [
        ["a", "b", "c"],
        ["d", "e", "f"],
        ["g", "h", "i"],
        ["j", "k", "l"],
        ["m", "n", "o"],
        ["p", "q", "r", "s"],
        ["t", "u", "v"],
        ["w", "x", "y", "z"]
    ]
    
    func dfs(_ idx: Int, _ chars: [Int], _ outputs: inout [String], _ results: inout [String]) {
        if idx == chars.count {
            results.append(outputs.joined())
            return
        }
        let letters = lettersArray[chars[idx] - 2]
        for letter in letters {
            outputs.append(letter)
            dfs(idx+1, chars, &outputs, &results)
            outputs.removeLast()
        }
    }

    var results = [String]()
    let chars = digits.compactMap { $0.hexDigitValue }
    var outputs = [String]()
    dfs(0, chars, &outputs, &results)
    return results
}
