//
//  RemoveNthFromEnd.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/31.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
    var fast = head
    for _ in 0 ..< n {
        fast = fast?.next
    }
    if fast == nil {
        return head?.next
    }
    var slow = head
    while fast?.next != nil {
        fast = fast?.next
        slow = slow?.next
    }
    slow?.next = slow?.next?.next
    return head
}
