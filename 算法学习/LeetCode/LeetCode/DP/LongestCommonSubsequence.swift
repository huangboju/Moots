//
//  LongestCommonSubsequence.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/5/4.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

/// https://mp.weixin.qq.com/s/ZhPEchewfc03xWv9VP3msg
/// https://leetcode-cn.com/problems/longest-common-subsequence/
class LongestCommonSubsequence {
    
    var memo: [[Int]] = []
    
    func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
        memo = Array(repeating: Array(repeating:-1, count: text2.count), count: text1.count)
        
        return dp(Array(text1), 0, Array(text2), 0)
    }
    
    func dp(_ text1: [Character], _ i: Int, _ text2: [Character], _ j: Int) -> Int {
        
        if i == text1.count || j == text2.count {
            return 0
        }
        
        if memo[i][j] != -1 {
            return memo[i][j]
        }
        
        if text1[i] == text2[j] {
            let result = dp(text1, i+1, text2, j+1) + 1
            memo[i][j] = result
            return result
        } else {
            memo[i][j] = max(dp(text1, i, text2, j+1), dp(text1, i+1, text2, j))
        }
        return memo[i][j]
    }
    
    /// https://leetcode-cn.com/problems/delete-operation-for-two-strings/
    func minDistance(_ word1: String, _ word2: String) -> Int {
        let lcs = longestCommonSubsequence(word1, word2)
        return word1.count - lcs + word2.count - lcs
    }
}

/// https://leetcode-cn.com/problems/minimum-ascii-delete-sum-for-two-strings/
class MinimumDeleteSum {
    
    var memo: [[Int]] = []
    
    func minimumDeleteSum(_ s1: String, _ s2: String) -> Int {
        memo = Array(repeating: Array(repeating: -1, count: s2.count), count: s1.count)
        return dp(Array(s1), 0, Array(s2), 0)
    }
    
    func dp(_ s1: [Character], _ i: Int, _ s2: [Character], _ j: Int) -> Int {
        var result = 0
        if s1.count == i {
            for n in s2.suffix(from: j) {
                result += Int(n.asciiValue ?? 0)
            }
            return Int(result)
        }
        
        if s2.count == j {
            for n in s1.suffix(from: i) {
                result += Int(n.asciiValue ?? 0)
            }
            return Int(result)
        }
        
        if memo[i][j] != -1 {
            return memo[i][j]
        }
        
        if s1[i] == s2[j] {
            memo[i][j] = dp(s1, i+1, s2, j+1)
        } else {
            let m = Int(s1[i].asciiValue ?? 0)
            let n = Int(s2[j].asciiValue ?? 0)
            memo[i][j] = min(dp(s1, i+1, s2, j) + m, dp(s1, i, s2, j+1) + n)
        }
        return memo[i][j]
    }
}
