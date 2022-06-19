//
//  DeleteDuplicates.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/6/16.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode.cn/problems/remove-duplicates-from-sorted-list/
func deleteDuplicates(_ head: ListNode?) -> ListNode? {
    var fast = head, slow = head
    while fast != nil {
        if fast?.val != slow?.val {
            slow?.next = fast
            slow = slow?.next
        }
        fast = fast?.next
    }
    slow?.next = nil
    return head
}
