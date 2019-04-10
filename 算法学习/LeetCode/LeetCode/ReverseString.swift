//
//  ReverseString.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/4/10.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

func reverseString(_ s: inout [Character]) {
    var start = 0
    var end = s.count - 1
    while start < end {
        s.swapAt(start, end)
        start += 1
        end -= 1
    }
}
