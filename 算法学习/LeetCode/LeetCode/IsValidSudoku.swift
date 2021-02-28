//
//  IsValidSudoku.swift
//  LeetCode
//
//  Created by jourhuang on 2021/2/28.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/valid-sudoku/
func isValidSudoku(_ board: [[Character]]) -> Bool {
    var rows: [Set<Character>] = Array(repeating: Set<Character>(), count: 9)
    var cols: [Set<Character>] = Array(repeating: Set<Character>(), count: 9)
    var box: [Set<Character>] = Array(repeating: Set<Character>(), count: 9)

    for r in 0..<9 {
        for c in 0..<9 {
            let char = board[r][c]
            if char == "." {
                continue
            }
            if rows[r].contains(char) {
                return false
            } else {
                rows[r].insert(char)
            }
            
            if cols[c].contains(char) {
                return false
            } else {
                cols[c].insert(char)
            }

            let boxIndex = r / 3 * 3 + c / 3
            if box[boxIndex].contains(char) {
                return false
            } else {
                box[boxIndex].insert(char)
            }
        }
    }
    
    return true
}
