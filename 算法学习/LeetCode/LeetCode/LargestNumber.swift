//
//  LargestNumber.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/10/9.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

// https://leetcode-cn.com/explore/interview/card/top-interview-quesitons-in-2018/270/sort-search/1169/

import Foundation

func largestNumber(_ nums: [Int]) -> String {
    var result = String(nums[0])
    var start = String(result.first ?? "0")
    var last = String(result.last ?? "0")
    for n in nums.dropFirst() {
        let str = "\(n)"
        let max = String(str.first ?? "0")
        let min = String(str.last ?? "0")
        if max < last && min > start {
            result = "\(n)" + result
            start = String(result.first!)
            last = String(result.last!)
        } else {
            result += "\(n)"
        }
    }
    return result
}
