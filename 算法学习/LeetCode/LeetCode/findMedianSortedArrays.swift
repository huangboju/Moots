//
//  findMedianSortedArrays.swift
//  LeetCode
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

func findMedianSortedArrays(a: [Int], b: [Int]) -> Double {
    let m = a.count
    let n = b.count

    if m > n {
        return findMedianSortedArrays(a: b, b: a)
    }

    var tmpMin = 0
    var tmpMax = m
    while tmpMin <= tmpMax {
        let i = (tmpMin + tmpMax) / 2
        let j = ((m + n + 1) / 2) - i
        if j > 0 && i < m && b[j-1] > a[i] {
            tmpMin = i + 1
        } else if i > 0 && j < n && a[i-1] > b[j] {
            tmpMax = i - 1
        } else {
            var firstNum: Int
            if i == 0 {
                firstNum = b[j-1]
            }
            else if j == 0 {
                firstNum = a[i-1]
            }
            else {
                firstNum = max(a[i-1], b[j-1])
            }

            // if (m + n) is odd
            if (m+n) & 1 != 0 {
                return Double(firstNum)
            }

            var secondNum: Int
            if i == m {
                secondNum = b[j]
            } else if j == n {
                secondNum = a[i]
            } else {
                secondNum = min(a[i], b[j])
            }

            return Double((firstNum + secondNum))/2.0
        }
    }
    return 0.0
}
