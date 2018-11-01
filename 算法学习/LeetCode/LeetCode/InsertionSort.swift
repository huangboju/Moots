//
//  insertionSort.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2018/10/16.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import Foundation

func insertionSort(a: [Int]) -> [Int] {
    var result = a
    for x in 1 ..< result.count {
        var y = x
        while y > 0 && result[y] < result[y - 1] { // 3
            result.swapAt(y - 1, y)
            y -= 1
        }
    }
    return result
}

func bubbleSort(_ a: [Int]) -> [Int] {
    var result = a

    for i in 0 ..< a.count {
        for j in i ..< a.count {
            if result[i] > result[j] {
                result.swapAt(i, j)
            }
        }
    }
    return result
}

func quicksort(_ a: [Int]) -> [Int] {
    guard a.count > 0 else { return a }
    
    let pivot = a[a.count/2]
    
    let less = a.filter { $0 < pivot }
    let equal = a.filter { $0 == pivot }
    let greater = a.filter { $0 > pivot }
    
    return quicksort(less) + equal + quicksort(greater)
}
