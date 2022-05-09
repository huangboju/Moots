//
//  GroupAnagrams.swift
//  LeetCode
//
//  Created by jourhuang on 2021/4/4.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/group-anagrams/submissions/
//func groupAnagrams(_ strs: [String]) -> [[String]] {
//    var group = [String: [String]]()
//    for str in strs {
//        group[String(str.sorted()), default: []].append(str)
//    }
//    return Array(group.values)
//}

func groupAnagrams(_ strs: [String]) -> [[String]] {
    
    let aAscic = Int("a".unicodeScalars.first!.value)
    var strDic = [[Int]: [String]]()
    
    for str in strs {
        var alphabet = [Int](repeating: 0, count: 26)
        
        for car in str.unicodeScalars {
            
            alphabet[Int(car.value) - aAscic] += 1
        }
        
        strDic[alphabet, default: []].append(str)
    }
    
    return Array(strDic.values)
}
