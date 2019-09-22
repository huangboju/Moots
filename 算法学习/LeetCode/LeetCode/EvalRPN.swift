//
//  EvalRPN.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/9/21.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

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
