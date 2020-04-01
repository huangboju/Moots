//
//  MergeTwoLists.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/31.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    var l1 = l1
    var l2 = l2
    let phead = ListNode(-1)
    var preN = phead
    while l1 != nil && l2 != nil {
        if l1!.val <= l2!.val {
            preN.next = l1
            l1 = l1?.next
        } else {
            preN.next = l2
            l2 = l2?.next
        }
        preN = preN.next!
    }
    preN.next = l1 == nil ? l2: l1
    return phead.next
}
