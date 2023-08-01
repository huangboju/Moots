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
    let dummy1 = ListNode(-1), dummy2 = ListNode(-1)
    var p1: ListNode? = dummy1, p2: ListNode? = dummy2
    var node = head
    while let n = node {
        if n.val < x {
            p1?.next = node
            p1 = p1?.next
        } else {
            p2?.next = node
            p2 = p2?.next
        }
        let temp = node?.next
        node?.next = nil
        node = temp
    }
    
    p1?.next = dummy2.next
    
    return dummy1.next
}
