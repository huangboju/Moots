//
//  DeleteNode.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/4/4.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

func deleteNode(_ node: ListNode?) {
    if node == nil || node?.next == nil { return }
    node?.val = node!.next!.val
    node?.next = node?.next?.next
}
