//
//  Calculate.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/9/19.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// 逆波兰表达式
// https://zh.wikipedia.org/wiki/%E9%80%86%E6%B3%A2%E5%85%B0%E8%A1%A8%E7%A4%BA%E6%B3%95
// https://www.jianshu.com/p/f2c88d983ff5

func calculate(_ s: String = "512+4*+3-") -> Int {
    var stack: [Int] = []
    for c in s {
        if let n = Int("\(c)") {
            stack.append(n)
        }
        switch "\(c)" {
        case "+":
            let n1 = stack.popLast()!
            let n2 = stack.popLast()!
            stack.append(n2 + n1)
        case "-":
            let n1 = stack.popLast()!
            let n2 = stack.popLast()!
            stack.append(n2 - n1)
        case "*":
            let n1 = stack.popLast()!
            let n2 = stack.popLast()!
            stack.append(n2 * n1)
        case "/":
            let n1 = stack.popLast()!
            let n2 = stack.popLast()!
            stack.append(n2 / n1)
        default:
            continue
        }
    }
    return stack[0]
}
