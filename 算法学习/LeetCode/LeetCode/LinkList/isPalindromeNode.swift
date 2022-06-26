//
//  isPalindromeNode.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/6/26.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

class isPalindromeNode {
    func isPalindrome(_ head: ListNode?) -> Bool {
        var fast = head, slow = head
        while fast != nil && fast?.next != nil {
            fast = fast?.next?.next
            slow = slow?.next
        }
        if fast != nil {
            slow = slow?.next
        }
        var right = reverse(slow)
        var left = head
        while right != nil {
            if right?.val != left?.val {
                return false
            }
            right = right?.next
            left = left?.next
        }
        return true
    }

    func reverse(_ head: ListNode?) -> ListNode? {
        var result: ListNode?
        var node = head
        while node != nil {
            let next = node?.next
            node?.next = result
            result = node
            node = next
        }
        return result
    }
}
