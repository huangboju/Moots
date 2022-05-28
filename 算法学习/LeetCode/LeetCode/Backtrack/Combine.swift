//
//  Combine.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/5/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

class CombineSolution {
    
    var result: [[Int]] = []
    var path: [Int] = []
    
    func combine(_ n: Int, _ k: Int) -> [[Int]] {
        backtrack(n, k, 1)
        return result
    }
    
    func backtrack(_ n: Int, _ k: Int, _ start: Int) {
        if path.count == k {
            result.append(path)
            return
        }

        if n < start { return }
        
        for i in start ... n {
            path.append(i)
            backtrack(n, k, i + 1)
            path.removeLast()
        }
    }
}
