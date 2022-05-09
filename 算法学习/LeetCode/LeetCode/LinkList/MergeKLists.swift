//
//  MergeKLists.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2020/3/27.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

public class ListNode {
     public var val: Int
     public var next: ListNode?
     public init(_ val: Int) {
         self.val = val
         self.next = nil
     }
 }

extension ListNode: CustomStringConvertible {
    public var description: String {
        var s = ""
        var node: ListNode? = self
        while node != nil {
            s += "\(node!.val)"
            node = node!.next
            s += " -> "
        }
        return s + "nil"
    }
}

func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
    if lists.isEmpty { return nil }
    var tmp: ListNode?
    var dict: [Int: Int] = [:]
    for node in lists {
        tmp = node
        while tmp != nil {
            if let key = tmp?.val {
                dict[key] = dict[key, default: 0] + 1
            }
            tmp = tmp?.next
        }
    }
    
    let result = ListNode(-1)
    tmp = result
    for key in dict.keys.sorted() {
        for _ in 0..<dict[key]! {
            tmp?.next = ListNode(key)
            tmp = tmp?.next
        }
    }

    return result.next
}
