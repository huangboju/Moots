//
//  RestoreIpAddresses.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2020/3/23.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func restoreIpAddresses(_ s: String) -> [String] {
    if s.count < 4 || s.count > 12 {
        return []
    }

    let characters: [Character] = Array(s)
    var result = [String]()
    var candidate = [String]()

    backtracking(characters, 0, &candidate, &result)

    return result
}
private func backtracking(_ characters: [Character], _ pos: Int, _ candidate: inout [String], _ result: inout [String]) {
    if candidate.count == 4 {
        result.append(candidate.joined(separator: "."))
        return
    }

    let charsLeft = characters.count - pos
    let groupsLeft = 4 - candidate.count
    let minLen = groupsLeft == 1 ? charsLeft - groupsLeft + 1 : 1
    let maxLen = characters[pos] == "0" ? 1 : min(3, charsLeft - groupsLeft + 1)

    if minLen > maxLen {
        return
    }

    for len in minLen...maxLen {
        let num = String(characters[pos..<(pos + len)])
        if Int(num)! > 255 {
            continue
        }
        candidate.append(num)
        backtracking(characters, pos + len, &candidate, &result)
        candidate.removeLast()
    }
}

