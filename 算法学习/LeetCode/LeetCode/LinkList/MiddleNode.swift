//
//  MiddleNode.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/2/19.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

func middleNode(_ head: ListNode?) -> ListNode? {
    var fast = head, slow = head
    while fast != nil && fast?.next != nil {
        slow = slow?.next
        fast = fast?.next?.next
    }
    return slow
}
