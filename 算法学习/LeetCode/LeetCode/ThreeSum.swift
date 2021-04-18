//
//  ThreeSum.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/21.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/3sum/
// nums = [-1, 0, 1, 2, -1, -4]
// sortedNums [-4, -1，-1, 0, 1, 2]

func threeSum(_ nums: [Int]) -> [[Int]] {
    if nums.count < 3 { return [] }

    var results: [[Int]] = []
    let sortedNums = nums.sorted()

    for i in 0..<sortedNums.count-1 {
        if sortedNums[i] > 0 { break }
        if i > 0 && sortedNums[i] == sortedNums[i-1] { continue }
        var lowerBound = i + 1
        var upperBound = nums.count - 1

        while lowerBound < upperBound {
            let sum = sortedNums[i] + sortedNums[lowerBound] + sortedNums[upperBound]
            if sum == 0 {
                results.append([sortedNums[i], sortedNums[lowerBound], sortedNums[upperBound]])

                while (lowerBound < upperBound && sortedNums[lowerBound] == sortedNums[lowerBound+1]) {
                    lowerBound += 1
                }
                while (lowerBound < upperBound && sortedNums[upperBound] == sortedNums[upperBound-1]) {
                    upperBound -= 1
                }
            }
            if sum > 0 {
                upperBound -= 1
            } else {
                lowerBound += 1
            }
        }
    }

    return results
}
