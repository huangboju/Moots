//
//  LetterCombinations.swift
//  LeetCode
//
//  Created by jourhuang on 2021/1/10.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func letterCombinations(_ digits: String) -> [String] {
    let count = digits.count
    if count == 0 { return [] }
    
    let lettersArray: [[Character]] = [
        ["a", "b", "c"],
        ["d", "e", "f"],
        ["g", "h", "i"],
        ["j", "k", "l"],
        ["m", "n", "o"],
        ["p", "q", "r", "s"],
        ["t", "u", "v"],
        ["w", "x", "y", "z"]]
    
    func dfs(_ idx: Int, _ chars: [Character], _ outputs: inout [Character], _ results: inout [String]) {
        if idx == chars.count {
            results.append(String(outputs))
        } else {
            let letters = lettersArray[chars[idx].hexDigitValue! - 2]
            for letter in letters {
                outputs.append(letter)
                dfs(idx+1, chars, &outputs, &results)
                outputs.removeLast()
            }
        }
    }

    var results = [String]()
    let chars = digits.map{ $0 }
    var outputs = [Character]()
    dfs(0, chars, &outputs, &results)
    return results
}
