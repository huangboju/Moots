//
//  DetectCycle.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/4/4.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func detectCycle(_ head: ListNode?) -> ListNode? {
    var p1 = head
    var p2 = head
    var time = 0
    while p2 != nil {
        let n1 = p1?.next
        var n2: ListNode?
        if time == 1 {
            n2 = p2?.next
        } else {
            n2 = p2?.next?.next
        }
        if n1?.val == n2?.val {
            if time == 0 {
                p1 = head
                p2 = n2
                time = 1
            } else {
                return n1
            }
        } else {
            p1 = n1
            p2 = n2
        }
    }
    return nil
}
