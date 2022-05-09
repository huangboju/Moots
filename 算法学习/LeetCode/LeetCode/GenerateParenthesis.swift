//
//  GenerateParenthesis.swift
//  LeetCode
//
//  Created by jourhuang on 2021/2/21.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/generate-parentheses/
func generateParenthesis(_ n: Int) -> [String] {
    func dfs(_ curStr: String, left: Int, right: Int, result: inout [String]) {
        if left == 0 && right == 0 {
            result.append(curStr)
            return
        }
        if left > right {
            return
        }
        if left > 0 {
            dfs(curStr + "(", left: left - 1, right: right, result: &result)
        }
        if right > 0 {
            dfs(curStr + ")", left: left, right: right - 1, result: &result)
        }
    }
    
    var result: [String] = []
    dfs("", left: n, right: n, result: &result)
    return result
}
