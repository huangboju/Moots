//
//  ZigZagConversion.swift
//  LeetCode
//
//  Created by jourhuang on 2021/1/9.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation


//The string "PAYPALISHIRING" is written in a zigzag pattern on a given number of rows like this: (you may want to display this pattern in a fixed font for better legibility)

//P   A   H   N
//A P L S I I G
//Y   I   R

func convert(_ s: String, _ numRows: Int) -> String {
    guard numRows > 1 else {
        return s
    }
    
    var letters = Array(repeating: "", count: numRows)
    let colStart = numRows * 2 - 2
    
    for (i, char) in s.enumerated() {
        let row = i % colStart
        if row < numRows {
            letters[row].append(char)
        } else {
            letters[colStart - row].append(char)
        }
    }
    
    return letters.joined()
}
