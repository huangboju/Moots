//
//  MinStack.swift
//  DataStructures
//
//  Created by xiAo_Ju on 2020/3/20.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import Foundation

class MinStack {
    var stack: [Int]
    var minStack: [Int]
    
    init() {
        stack = []
        minStack = []
    }
    
    func push(_ x: Int) {
        stack.append(x)
        if minStack.isEmpty {
            minStack.append(x)
        } else {
            minStack.append(min(x, minStack.last!))
        }
    }
    
    func pop() {
        stack.removeLast()
        minStack.removeLast()
    }
    
    func top() -> Int {
        return stack.last!
    }
    
    func getMin() -> Int {
        return minStack.last!
    }
}
