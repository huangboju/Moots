//
//  EvalRPN.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/9/21.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// 逆波兰表达式
// https://zh.wikipedia.org/wiki/%E9%80%86%E6%B3%A2%E5%85%B0%E8%A1%A8%E7%A4%BA%E6%B3%95
// https://www.jianshu.com/p/f2c88d983ff5

func evalRPN(_ tokens: [String]) -> Int {
    let operators: Set<String> = ["*","+","/","-"]
    var stack = Array<Int>()
    for token in tokens {
        if operators.contains(token) {
            let num1 = stack.removeLast()
            let index = stack.count - 1
            switch token {
            case "*":
                stack[index] *= num1
            case "-":
                stack[index] -= num1
            case "+":
                stack[index] += num1
            case "/":
                stack[index] /= num1
            default:
                break
            }
            continue
        }
        stack.append(Int(token)!)
    }
    return stack[0]
}
