//
//  AddTwoNumbers.swift
//  LeetCode
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/add-two-numbers/
func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    var ll1 = l1 ,ll2 = l2 ,node = ListNode(0)
    let nodes = node
    var flag = 0
    while ll1?.val != nil || ll2?.val != nil || flag == 1 {
        let num1 = ll1?.val ?? 0
        let num2 = ll2?.val ?? 0
        var num = num1 + num2 + flag
        if num > 9 {
            num = num % 10
            flag = 1
        } else {
            flag = 0
        }
        node.next = ListNode(num)
        node = node.next!
        ll1  = ll1?.next
        ll2  = ll2?.next
    }
    return nodes.next
}


// (2 -> 4 -> 3) + (5 -> 6 -> 4)
func _addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    var node1 = l1
    var node2 = l2
    var node: ListNode? = ListNode(0)
    let result = node
    var flag = 0
    
    while node1 != nil || node2 != nil || flag == 1 {
        let v1 = node1?.val ?? 0
        let v2 = node2?.val ?? 0
        var sum = v1 + v2 + flag
        if sum > 9 {
            sum %= 10
            flag = 1
        } else {
            flag = 0
        }
        node?.next = ListNode(sum)
        node = node?.next
        node1 = node1?.next
        node2 = node2?.next
    }

    return result?.next
}
