//
//  ReverseWords.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/4/5.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation


//"  hello world!  "
//"world! hello"
func reverseWords(_ s: String) -> String {
    var words = s.split(separator: " ")
    words.reverse()
    return words.joined(separator: " ")
}
