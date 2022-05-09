//
//  ContainsDuplicate.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/4/28.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

func containsDuplicate(_ nums: [Int]) -> Bool {
    let set = Set(nums)
    return set.count != nums.count
}
