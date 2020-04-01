//
//  RemoveNthFromEnd.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/31.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
    var first = head
    for _ in 0..<n {
        first = first?.next
    }
    if first == nil {
        return head?.next
    }
    var sec = head
    while first?.next != nil {
        first = first?.next
        sec = sec?.next
    }
    sec?.next = sec?.next?.next
    return head
//    var index = 0
//    var dict: [Int: ListNode] = [:]
//    var node = head
//    while node != nil {
//        dict[index] = node
//        node = node?.next
//        index += 1
//    }
//    dict[index - n - 1]?.next = dict[index - 1]
//    return head
}
