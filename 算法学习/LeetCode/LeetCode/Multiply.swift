//
//  Multiply.swift
//  LeetCode
//
//  Created by jourhuang on 2021/3/28.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

// https://leetcode-cn.com/problems/multiply-strings/
import Foundation

func multiply(_ num1: String, _ num2: String) -> String {
    if num1 == "0" || num2 == "0" {
        return "0"
    }
    let arr1 = num1.compactMap { Int(String($0)) }
    let arr2 = num2.compactMap { Int(String($0)) }
    var res = [Int](repeating: 0, count: arr1.count + arr2.count)
    for (i, n1) in arr1.enumerated().reversed() {
        for (j, n2) in arr2.enumerated().reversed() {
            let p1 = i+j
            let p2 = i+j+1
            var mul = n1 * n2
            mul += res[p2]
            res[p1] += mul / 10
            res[p2] = mul % 10
        }
    }
    
    var str = ""
    var i = res[0] == 0 ? 1 : 0
    for _ in i..<res.count {
        str += String(res[i])
        i += 1
    }
    return str
}
