//
//  GetIntersectionNode.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2022/3/5.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/intersection-of-two-linked-lists/submissions/
func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
    var p1 = headA, p2 = headB
    while p1 !== p2 {
        if p1 == nil {
            p1 = headB
        } else {
            p1 = p1?.next
        }
        if p2 == nil {
            p2 = headA
        } else {
            p2 = p2?.next
        }
    }
    return p2
}
