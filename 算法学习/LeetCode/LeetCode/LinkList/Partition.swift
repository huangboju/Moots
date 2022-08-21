//
//  Partition.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/8/9.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode.cn/problems/partition-list/submissions/
func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
    var dummy1: ListNode? = ListNode(-1)
    var dummy2: ListNode? = ListNode(-1)
    var p1 = dummy1, p2 = dummy2
    var head = head
    while head != nil {
        if (head?.val ?? 0) < x {
            p1?.next = head
            p1 = p1?.next
        } else {
            p2?.next = head
            p2 = p2?.next
        }
        let temp = head?.next
        head?.next = nil
        head = temp
    }
    
    p1?.next = dummy2?.next
    
    return dummy1?.next
}
