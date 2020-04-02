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

    var arr: [ListNode] = []
    var node = head
    while let n = node {
        arr.append(n)
        node = node?.next
    }
    let target = arr[arr.count - n - 1]
    target.next = target.next?.next
    return head
}
