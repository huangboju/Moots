//
//  RestoreIpAddresses.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2020/3/23.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func restoreIpAddresses(_ s: String) -> [String] {
    if s.count < 4 || s.count > 12 { return [] }
    
    let chars = Array(s)
    var result: [String]  = []
    var candidate: [String] = []
    
    backTracking(chars, pos: 0, candidate: &candidate, result: &result)
    
    return result
}

private func backTracking(_ chars:[String.Element], pos: Int, candidate: inout [String], result: inout [String]) {
    if candidate.count == 4 {
        result.append(candidate.joined(separator: "."))
        return
    }
    
    let charsLeft = chars.count - pos
    let groupsLeft = 4 - candidate.count
    let minLen = groupsLeft == 1 ? charsLeft : 1
    let maxLen = chars[pos] == "0" ? 1 : min(3, charsLeft - groupsLeft + 1)
    
    if minLen > maxLen {
        return
    }
    
    for len in minLen...maxLen {
        let n = String(chars[pos..<(pos + len)])
        if Int(n)! > 255 { continue }
        candidate.append(n)
        backTracking(chars, pos: pos + len, candidate: &candidate, result: &result)
        candidate.removeLast()
    }
}


