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

//func reverseList(_ head: ListNode) -> ListNode? {
//    if head == nil || head.next == nil {
//        return head
//    }
//    let last = reverse(head?.next)
//    head?.next?.next = head
//    head?.next = null
//    return last
//}

//var successor: ListNode?
//func reverseN(_ head: ListNode?, n: Int) -> ListNode? {
//    if n == 1 {
//        // 记录第 n + 1 个节点
//        successor = head?.next
//        return head
//    }
//    let last = reverseN(head?.next, n: n - 1)
//    head?.next?.next = head
//    head?.next = successor
//    return last
//}

class ReverseBetween {
    func reverseBetween(_ head: ListNode?, _ left: Int, _ right: Int) -> ListNode? {
        let dummy = ListNode(-1)
        dummy.next = head
        var node: ListNode? = dummy

        for _ in 0 ..< left - 1 {
            node = node?.next
        }
        let firstNode = node
        let midNode = firstNode?.next

        for _ in 0 ... right - left {
            node = node?.next
        }
        let thirdNode = node?.next

        firstNode?.next = nil
        node?.next = nil

        _ = reverseLink(midNode)

        firstNode?.next = node
        midNode?.next = thirdNode

        return dummy.next
    }

    func reverseLink(_ head: ListNode?) -> ListNode? {
        var result: ListNode?
        var node = head
        while node != nil {
            let next = node?.next
            node?.next = result
            result = node
            node = next
        }
        return result
    }
    
//    func reverseBetween(_ head: ListNode?, _ m: Int, _ n: Int) -> ListNode? {
//        // base case
//        if m == 1 {
//            return reverseN(head, n)
//        }
//        // 前进到反转的起点触发 base case
//        head?.next = reverseBetween(head?.next, m - 1, n - 1)
//        return head
//    }
//
//    var successor: ListNode? = nil // 后继节点：记录在反转前N个节点时，第N+1个节点
//    // 反转以Head为起始的N个节点，返回新的头结点
//    func reverseN(_ head: ListNode?, _ n: Int) -> ListNode? {
//        if n == 1 { // n = 1 反转一个元素，即不反转直接返回
//            // 记录后继节点
//            successor = head?.next
//            return head
//        }
//        // 以 head.next 为起点，需要反转前 n - 1 个节点, last为反转之后的头结点
//        let last = reverseN(head?.next, n-1)
//        head?.next?.next = head
//        // 让反转之后的 tail 节点和后继节点连起来
//        head?.next = successor
//        return last
//    }

}
