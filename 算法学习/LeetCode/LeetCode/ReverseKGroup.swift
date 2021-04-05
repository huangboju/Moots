//
//  ReverseKGroup.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2021/2/23.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
    func reverse(_ head: ListNode?) -> ListNode? {
        var pre: ListNode?
        var curr = head
        while curr != nil {
            let next = curr?.next
            curr?.next = pre
            pre = curr
            curr = next
        }
        return pre
    }

    let dummy = ListNode(-1)
    dummy.next = head
    var pre: ListNode? = dummy
    var end: ListNode? = dummy

    while end?.next != nil {
        for _ in 1...k {
            end = end?.next
        }
        
        if end == nil {
            break
        }
        
        let start = pre?.next
        let next = end?.next
        end?.next = nil
        pre?.next = reverse(start)
        start?.next = next
        pre = start
        end = pre
    }
    
    return dummy.next
}
