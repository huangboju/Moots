//
//  main.swift
//  DataStructures
//
//  Created by xiAo_Ju on 2018/10/12.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import Foundation

var bits = BitSet(size: 140)

print(bits)

var a = FixedSizeArray(maxSize: 10, defaultValue: 0)

//print(a[5])

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

extension ListNode : CustomStringConvertible {
    public var description: String {
        var string = "\(val)"
        var node = self.next
        
        while node != nil {
            string = string + " -> " + "\(node!.val)"
            node = node?.next
        }
        string = string + " -> " + "nil"
        return string
    }
}

extension Array where Element == Int {
    var linkedList: ListNode {
        return reversed().reduce(ListNode(0)) { (r, v) -> ListNode in
            let new = ListNode(v)
            new.next = r.val == 0 ? nil : r
            return new
        }
    }
}

let strings = ["a", "b", "c"]

//["a": ["b": ["c":[:]]]]

let result = strings.reversed().reduce([:]) { dict, str in
    return [str: dict]
}

let head = (0..<10).reversed().reduce(ListNode(0)) { (r, v) -> ListNode in
    let new = ListNode(v)
    new.next = r.val == 0 ? nil : r
    return new
}

//let _nn = ListNode(0)
//
//let node = (0..<10).reduce(_nn) { (r, v) -> ListNode? in
//    r?.next = ListNode(v)
//    return r?.next
//}
//
//print(_nn)

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

print(Solution.oddEvenList(head))

print(Solution.isPalindrome([1,1,2,1].linkedList))
