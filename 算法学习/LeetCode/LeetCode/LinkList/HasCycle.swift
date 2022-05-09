//
//  HasCycle.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/3/5.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

/// https://leetcode-cn.com/problems/linked-list-cycle/submissions/
func hasCycle(_ head: ListNode?) -> Bool {
    var slow = head, fast = head
    while fast != nil && fast?.next != nil {
        slow = slow?.next
        fast = fast?.next?.next
        if slow === fast {
            return true
        }
    }
    return false
}
