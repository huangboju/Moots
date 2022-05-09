//
//  RotateRight.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2021/10/31.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/rotate-list/
func rotateRight(_ head: ListNode?, _ k: Int) -> ListNode? {
    if head == nil || head?.next == nil {
        return head
    }
    var pre = head
    var count = 1
    while pre?.next != nil {
        pre = pre?.next
        count += 1
    }
    // 首尾相连(新首节点为尾部节点)
    pre?.next = head
    var step = count - k % count
    while step != 0 {
        step -= 1
        pre = pre?.next
    }
    let newHead = pre?.next
    pre?.next = nil
    return newHead
}
