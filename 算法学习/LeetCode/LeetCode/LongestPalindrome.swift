//
//  LongestPalindrome.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/30.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/longest-palindromic-substring/solution/swift-026zui-chang-hui-wen-zi-chuan-by-y-9k06/
// https://www.cxyxiaowu.com/2665.html
func longestPalindrome(_ s: String) -> String {
    if s.isEmpty {
        return s
    }
    
    // 1.间隔之间先插入#
    var S = ["#"]
    for character in s {
        S.append(String(character))
        S.append("#")
    }
    
    // 2.遍历找出以每个节点作为轴最长半径
    var maxId = 0
    var max = 0
    var P = [1]
    var maxLength = 1
    var maxLengthIndex = 0
    
    for i in 1..<S.count {
        // j是相对于maxId的i的左边的对称点
        let j = maxId - (i - maxId)
        
        if max > i && j >= 0 {
            // 优化部分,请见文章
            P.append(min(P[j], max - i))
        } else {
            P.append(1)
        }
        // 循环判断以i位置为中心的左右两侧是否相同,相同加1
        while i + P[i] <= S.count - 1 && i - P[i] >= 0 && S[i + P[i]] == S[i - P[i]]{
            P[i] += 1
        }
        
        if i + P[i] - 1 > max {
            // 以i为中心的子回文的最后一个元素的位置
            max = i + P[i] - 1
            // 记录i为回文子串的中心id
            maxId = i
        }
        
        // 判断最长回文的长度,并记录
        if P[i] > maxLength {
            maxLength = P[i]
            maxLengthIndex = i
        }
        print("i:\(i) maxId:\(maxId) max:\(max) maxLength:\(maxLength) maxLengthIndex:\(maxLengthIndex) P:\(P)")
    }
    let leftIndex = s.index(s.startIndex, offsetBy: (maxLengthIndex - (maxLength - 1))/2)
    let rightIndex = s.index(leftIndex, offsetBy:maxLength - 1 - 1)
    return String(s[leftIndex...rightIndex])
}
