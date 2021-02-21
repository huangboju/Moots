//
//  SwapPairs.swift
//  LeetCode
//
//  Created by jourhuang on 2021/2/21.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/swap-nodes-in-pairs/

func swapPairs(_ head: ListNode?) -> ListNode? {
    let dummy = ListNode(-1)
    dummy.next = head
    var tmp: ListNode?  = dummy
    while let node1 = tmp?.next, let node2 = node1.next {
        tmp?.next = node2
        node1.next = node2.next
        node2.next = node1
        tmp = node1
    }
    return dummy.next
}

//func swapPairs(_ head: ListNode?) -> ListNode? {
//    guard let first = head else { return nil }
//    guard let second = head?.next else { return first }
//
//    let third = head?.next?.next
//
//    second.next = first
//
//    first.next = swapPairs(third)
//
//    return second
//}

// 2143

// -11234
// node1 1234
// node2 234

// tmp -1234
// node1 134
// node2 2134
