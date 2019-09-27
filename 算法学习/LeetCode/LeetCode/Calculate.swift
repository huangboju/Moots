//
//  Calculate.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/9/19.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

class Solution {
    class func calculate(_ s: String) -> Int {

        var result = 0
        var stack: [Int] = []
        var num = 0
        var sign = "+"
        
        for (i, char) in s.enumerated() {
            let isNum = char >= "0" && char <= "9"
            
            if isNum {
                num = num * 10 + Int(String(char))!
            }
            
            if !isNum && char != " " || i == s.count - 1 {
                switch sign {
                case "+":
                    stack.append(num)
                case "-":
                    stack.append(-num)
                case "*":
                    stack.append(stack.removeLast() * num)
                case "/":
                    stack.append(stack.removeLast() / num)
                default:
                    break
                }
                
                num = 0
                sign = String(char)
            }
        }
        
        for n in stack {
            result += n
        }

        return result
    }
}
