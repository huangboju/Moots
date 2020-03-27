//
//  LinklistSolution.swift
//  DataStructures
//
//  Created by 黄伯驹 on 2020/3/27.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import Foundation

class Solution {
    func sortList(_ head: ListNode?) -> ListNode? {
        var node = head
        var arrayInt = [Int]()
        
        while node != nil {
            arrayInt.append(node?.val ?? 0)
            node = node?.next
        }
        arrayInt.sort(by: <)
        node = head
        var num = 0
        while node != nil {
            node?.val = arrayInt[num]
            node = node?.next
            num += 1
        }
        return head
    }
    
    class func reverseList(_ head: ListNode?) -> ListNode? {
        if head == nil || head?.next == nil {
            return head
        }
        var result: ListNode?
        var node = head
        while node != nil {
            let tmp = node?.next
            node?.next = result
            result = node
            node = tmp
        }
        return result
    }

//输入: 1->2->3->4->5->NULL
//输出: 1->3->5->2->4->NULL
    class func oddEvenList(_ head: ListNode?) -> ListNode? {
        if head == nil || head?.next == nil { return head }
        var pre = head
        var last = head?.next
        let temp = last
        print("tmp", temp)
        while last != nil && last?.next != nil {
            print("pre", pre)
            print("last", last)
            print("\n")
            pre?.next = last?.next
            print("pre", pre)
            print("last", last)
            print("\n")
            pre = pre?.next
            print("pre", pre)
            print("last", last)
            print("\n")
            last?.next = pre?.next
            print("pre", pre)
            print("last", last)
            print("\n")
            last = last?.next
            print("pre", pre)
            print("last", last)
            print("\n")
        }
        print("🍀🍀🍀🍀🍀")
        print("pre", pre)
        print("last", last)
        print("tmp", temp)
        pre?.next = temp
        print("\n")
        print("pre", pre)
        print("last", last)
        return head
    }
    
    class func isPalindrome(_ head: ListNode?) -> Bool {
        var fast = head, slow = head, head = head
        while fast != nil && fast!.next != nil {
            fast = fast?.next?.next
            slow = slow?.next
        }
        var rev = reverse(slow)
        while rev != nil && head != nil {
            if rev?.val != head?.val {
                return false
            }
            head = head?.next
            rev = rev?.next
        }
        return true
    }
    
    class func reverse(_ head: ListNode?) -> ListNode? {
        var pre: ListNode?
        var cur = head
        while cur != nil {
            let next = cur?.next
            cur?.next = pre
            pre = cur
            cur = next
        }
        return pre
    }
}
