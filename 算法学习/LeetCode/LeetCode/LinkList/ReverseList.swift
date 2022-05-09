//
//  ReverseList.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2021/10/31.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/reverse-linked-list/submissions/
func reverseList(_ head: ListNode?) -> ListNode? {
    var result: ListNode?
    var head = head

    while head != nil {
        let next = head?.next
        head?.next = result
        result = head
        head = next
    }

    return result
}
