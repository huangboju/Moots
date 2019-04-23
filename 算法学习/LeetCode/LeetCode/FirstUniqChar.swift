//
//  FirstUniqChar.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/4/23.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

func firstUniqChar(_ s: String) -> Int {
    //创建一个含有26个为0的值的数组
    let scalars = s.unicodeScalars
    var array = Array<Int>(repeating: 0, count: 26)
    for character in scalars {
        let index = Int(character.value - 97)
        //记录字符出现的次数
        array[index] += 1
    }
    //再次循环string，使用enumerated()获取到字符串的索引
    for (index, character) in scalars.enumerated() {
        let count = array[Int(character.value - 97)]
        if count == 1 {
            return index
        }
    }
    return -1
}
