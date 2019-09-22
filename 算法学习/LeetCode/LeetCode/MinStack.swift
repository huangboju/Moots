//
//  MinStack.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/9/22.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

public class MinStack {

    private var values = [Int]()
    private var auxiliaryValues = [Int]()
    
    /** initialize your data structure here. */
    public init() {}
    
    public func push(_ x: Int) {
        values.append(x)
        
        if let lastAuxiliary = auxiliaryValues.last {
            if x < lastAuxiliary {
                auxiliaryValues.append(x)
            } else {
                auxiliaryValues.append(lastAuxiliary)
            }
        } else {
            auxiliaryValues.append(x)
        }
    }
    
    public func pop() {
        _ = values.popLast()
        _ = auxiliaryValues.popLast()
    }
    
    public func top() -> Int {
        guard let last = values.last else { return -1 }
        return last
    }
    
    public func getMin() -> Int {
        guard let lastAuxiliary = auxiliaryValues.last else { return -1 }
        return lastAuxiliary
    }
}
