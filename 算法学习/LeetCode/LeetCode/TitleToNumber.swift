//
//  TitleToNumber.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/9/28.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

// https://leetcode-cn.com/explore/interview/card/top-interview-quesitons-in-2018/268/hash-map/1162/

import Foundation

//func titleToNumber(_ s: String) -> Int {
//    var dict: [String: Int] = [:]
//    for (i, n) in (65 ... 90).enumerated() {
//        dict["\(UnicodeScalar(n)!)"] = i
//    }
//    var result = 0
//    for (i, char) in s.reversed().enumerated() {
//        guard let value = dict["\(char)"] else { continue }
//        result += (Int(pow(Double(26), Double(i))) * value)
//    }
//    return result
//}

func titleToNumber(_ s: String) -> Int {
  var result = 1/26
  for char in s {
    result = result * 26 + Int(char.asciiValue ?? 0) - 64
  }
  return result
}
