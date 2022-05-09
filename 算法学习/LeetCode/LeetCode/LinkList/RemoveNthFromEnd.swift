//
//  RemoveNthFromEnd.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/31.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/remove-nth-node-from-end-of-list/
func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
    let dummy: ListNode? = ListNode(-1)
    dummy?.next = head
    var fast = dummy
    for _ in 0 ... n {
        fast = fast?.next
    }
    var slow = dummy
    while fast != nil {
        slow = slow?.next
        fast = fast?.next
    }
    slow?.next = slow?.next?.next
    return dummy?.next
}
