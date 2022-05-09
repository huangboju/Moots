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
    // -11234
    // node1 1234
    // node2 234
    while let node1 = tmp?.next, let node2 = node1.next {
        // -1234
        tmp?.next = node2
        // 134
        node1.next = node2.next
        // 2134
        node2.next = node1
        tmp = node1
    }
    return dummy.next
}
//
//
///*
//Reverse every 3 nodes in the linked list.
//
//Example
//input:   1 --> 2 --> 3 --> 4 --> 5 --> 6
//output:  3 --> 2 --> 1 --> 6 --> 5 --> 4
//*/
//
//class ListNode {
//  var val: Int
//  var next: ListNode?
//  init(_ val: Int) {
//    self.val = val
//  }
//}
//
//func reverseList(_ head: ListNode?) -> ListNode? {
//    var node = head
//    var result: ListNode? = ListNode(-1)
//    let temp = result
//    while let node1 = node,
//          let node2 = node1.next,
//          let node3 = node2.next {
//      let next = node3.next
//      result?.next = ListNode(node3.val)
//      result?.next?.next = ListNode(node2.val)
//      result?.next?.next?.next = ListNode(node1.val)
//      result = result?.next?.next?.next
//      node = next
//    }
//  return temp?.next
//}
//
//var input: ListNode? = ListNode(1)
//let head = input
//for i in 2...6 {
//  input?.next = ListNode(i)
//  input = input?.next
//}
//
//func log(_ head: ListNode?) {
//  var temp = head
//  while temp != nil {
//    print(temp?.val ?? 0)
//    temp = temp?.next
//  }
//}
//
//// log(head)
//
//let result = reverseList(head)
//print("\noutput: ")
//log(result)




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
