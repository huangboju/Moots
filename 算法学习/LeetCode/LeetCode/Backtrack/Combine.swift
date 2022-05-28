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

// https://leetcode.cn/problems/combination-sum/
class CombinationSum {
    var result: [[Int]] = []
    
    var path: [Int] = []
    
    func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
        backtrack(candidates, target, 0)
        return result
    }
    
    func backtrack(_ candidates: [Int], _ target: Int, _ start: Int) {
        if target == 0 {
            result.append(path)
            return
        }
        if target < 0 {
            return
        }
        
        for i in start ..< candidates.count {
            
            path.append(candidates[i])
            backtrack(candidates, target-candidates[i], i)
            path.removeLast()
        }
    }
}


// https://leetcode.cn/problems/combination-sum-ii/
class CombinationSum2 {
    var result: [[Int]] = []
    
    var path: [Int] = []
    
    var sum = 0
    
    func combinationSum2(_ candidates: [Int], _ target: Int) -> [[Int]] {
        
        backtrack(candidates.sorted(), target, 0)
        
        return result
    }
    
    func backtrack(_ candidates: [Int], _ target: Int, _ start: Int) {
        
        if sum == target {
            result.append(path)
            return
        }
        
        if sum > target {
            return
        }
        
        for i in start ..< candidates.count {
            
            if i > start && candidates[i] == candidates[i-1] {
                continue
            }
            
            let n = candidates[i]
            path.append(n)
            sum += n
            backtrack(candidates, target, i + 1)
            sum -= n
            path.removeLast()
        }
    }
}
