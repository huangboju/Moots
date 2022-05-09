//
//  ReverseKGroup.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2021/2/23.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation
// https://labuladong.gitee.io/algo/2/18/19/
func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
    func reverse(_ head: ListNode?, _ head2: ListNode?) -> ListNode? {
        var pre: ListNode?
        var curr = head
        while curr !== head2 {
            let next = curr?.next
            curr?.next = pre
            pre = curr
            curr = next
        }
        return pre
    }

    if head == nil { return nil }
    var a = head, b = head
    
    for _ in 0 ..< k {
        guard let t = b else { return head }
        b = t.next
    }
    
    let newHead = reverse(a, b)

    a?.next = reverseKGroup(b, k)
    
    return newHead
}
