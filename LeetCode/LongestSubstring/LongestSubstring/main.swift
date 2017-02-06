//
//  main.swift
//  LongestSubstring
//
//  Created by 伯驹 黄 on 2017/2/5.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import Foundation

func lengthOfLongestSubstr(_ s: String) -> Int {
    var subStr = ""
    var tempStr = ""
    for c in s.characters {
        if subStr.contains("\(c)") {
            subStr = "\(c)"
        } else {
            subStr.append(c)
        }
    }
    if subStr.characters.count > tempStr.characters.count {
        tempStr = subStr
    }
    return tempStr.characters.count
}

print(lengthOfLongestSubstr("abcabcadd"), "😁")


private extension String {
    func randomAccessCharactersArray() -> [Character] {
        return Array(characters)
    }
}

struct Medium_003_Longest_Substring_Without_Repeating_Characters {
    // t = O(N), s = O(1)
    static func longest(_ s: String) -> Int { // 思路通过相同字符间隔去查找出最大长度
        let charArr = s.randomAccessCharactersArray()
        let len = charArr.count
        if len <= 1 {
            return len
        } else {
            var tmpMaxLen = 1
            var maxLen = 1
            var hashMap: [Character: Int] = [charArr[0]: 0]
            for i in 1..<len {
                if let lastPosition = hashMap[charArr[i]] { // 已经存在的字符
                    if lastPosition < i - tmpMaxLen {
                        tmpMaxLen += 1 // 这里应该永远不会执行
                    } else {
                        tmpMaxLen = i - lastPosition
                    }
                } else {
                    tmpMaxLen += 1
                }
                hashMap[charArr[i]] = i
                if tmpMaxLen > maxLen {
                    maxLen = tmpMaxLen
                }
            }
            return maxLen
        }
    }
}

print(Medium_003_Longest_Substring_Without_Repeating_Characters.longest("abcabcabbd"))
