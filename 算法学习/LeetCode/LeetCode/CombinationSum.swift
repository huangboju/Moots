//
//  CombinationSum.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2018/11/7.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import Foundation

func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
    func _dfs(_ candidates: [Int], _ target: Int, _ res: inout [[Int]], _ path: inout [Int], _ index: Int) {
        if target == 0 {
            res.append(Array(path))
            return
        }
        
        for i in index..<candidates.count {
            guard candidates[i] <= target else {
                break
            }
            
            path.append(candidates[i])
            _dfs(candidates, target - candidates[i], &res, &path, i)
            path.removeLast()
        }
    }

    var res = [[Int]]()
    var path = [Int]()

    let result = candidates.sorted(by: <)
    
    _dfs(result, target, &res, &path, 0)
    
    return res
}

func combinationSum2(_ candidates: [Int], _ target: Int) -> [[Int]] {
    func dfs(_ res: inout [[Int]], _ path: inout [Int], _ target: Int, _ candidates: [Int], _ index: Int) {
        if target == 0 {
            res.append(Array(path))
            return
        }
        
        for i in index ..< candidates.count {
            guard candidates[i] <= target else {
                break
            }
            
            if i > 0 && candidates[i] == candidates[i - 1] && i != index {
                continue
            }
            
            path.append(candidates[i])
            dfs(&res, &path, target - candidates[i], candidates, i + 1)
            path.removeLast()
        }
    }

    var res = [[Int]](), path = [Int]()
    
    dfs(&res, &path, target, candidates.sorted(), 0)
    
    return res
}
