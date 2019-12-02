//
//  MaxPoints.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/11/19.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

/// https://leetcode-cn.com/explore/interview/card/top-interview-quesitons-in-2018/274/math/1187/


func maxPoints(_ points: [[Int]]) -> Int {
    var result: Int = 0
    for i in 0 ..< points.count {
        var map: [String: Int] = [:]
        var same: Int = 0
        var maxP: Int = 0
        for j in i + 1 ..< points.count {
            var x = points[j][0] - points[i][0]
            var y = points[j][1] - points[i][1]
            if x == 0 && y == 0 {
                // same point
                same += 1
                continue
            }
            let r = gcd(x, y)
            if r != 0 {
                x /= r
                y /= r
            }
            let d = "\(x)@\(y)"
            map[d, default: 0] += 1
            maxP = max(maxP, map[d]!)
        }
        result = max(result, maxP + same + 1) // 1 for itself
    }
    return result
}

func gcd(_ m: Int, _ n: Int) -> Int {
  var a = 0
  var b = max(m, n)
  var r = min(m, n)

  while r != 0 {
    a = b
    b = r
    r = a % b
  }
  return b
}
