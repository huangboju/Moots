//
//  RunLengthEncoding.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2019/4/20.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation


func compress(_ str: String){
    var i = 0
    var count = 1
    var result = ""
    
    for char in str {
        if i < str.count - 1 && ((str as NSString).substring(with: NSRange(location: i + 1, length: 1)) == String(char)) {
            count += 1
        } else {
            result += "\(char)\(count)"
            count = 1
        }
        i += 1
    }
    print(result)
}
