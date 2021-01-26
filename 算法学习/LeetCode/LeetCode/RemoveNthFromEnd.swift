//
//  RemoveNthFromEnd.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/31.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
//    var first = head
//    for _ in 0..<n {
//        first = first?.next
//    }
//    if first == nil {
//        return head?.next
//    }
//    var sec = head
//    while first?.next != nil {
//        first = first?.next
//        sec = sec?.next
//    }
//    sec?.next = sec?.next?.next
//    return head

    var dummyHead = ListNode(-1)
    dummyHead.next = head
    var fast = dummyHead
    var slow = dummyHead
    
    for _ in 0..<n {
        
        fast = fast.next!
    }
    
    while fast.next != nil {
        fast = fast.next!
        slow = slow.next!
    }
    
    slow.next = slow.next!.next
    
    return dummyHead.next
}
