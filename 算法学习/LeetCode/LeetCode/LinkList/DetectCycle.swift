//
//  DetectCycle.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/4/4.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode.cn/problems/linked-list-cycle-ii/submissions/
func detectCycle(_ head: ListNode?) -> ListNode? {
    var fast = head, slow = head
    while fast != nil && fast?.next != nil {
        slow = slow?.next
        fast = fast?.next?.next
        if fast === slow {
            break
        }
    }
    if fast == nil || fast?.next == nil {
        return nil
    }
    slow = head
    while slow !== fast {
        slow = slow?.next
        fast = fast?.next
    }
    return slow
}
