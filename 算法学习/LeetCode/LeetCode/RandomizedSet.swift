//
//  RandomizedSet.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/9/30.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

class RandomizedSet {
    
    var dict: [Int: Int] = [:]

    /** Initialize your data structure here. */
    init() {
        
    }
    
    /** Inserts a value to the set. Returns true if the set did not already contain the specified element. */
    func insert(_ val: Int) -> Bool {
        if dict[val] == nil {
            dict[val] = val
            return true
        }
        return false
    }
    
    /** Removes a value from the set. Returns true if the set contained the specified element. */
    func remove(_ val: Int) -> Bool {
        if dict[val] == nil {
            return false
        }
        dict[val] = nil
        return true
    }

    /** Get a random element from the set. */
    func getRandom() -> Int {
        let randomIndex = Int.random(in: 0..<dict.keys.count)
        let randomKey = ([Int](dict.keys))[randomIndex]
        return dict[randomKey]!
    }
}
