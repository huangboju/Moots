//
//  MergeTwoLists.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/31.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

//1->2->4, 1->3->4
//1->1->2->3->4->4
// https://leetcode-cn.com/problems/merge-two-sorted-lists/submissions/
func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    var node1 = l1
    var node2 = l2
    let phead = ListNode(-1)
    var preN = phead
    while let n1 = node1, let n2 = node2 {
        if n1.val <= n2.val {
            preN.next = node1
            node1 = node1?.next
        } else {
            preN.next = node2
            node2 = node2?.next
        }
        preN = preN.next!
    }
    preN.next = node1 ?? node2
    return phead.next
}
