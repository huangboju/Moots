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

print(Solution.oddEvenList(head))

print(Solution.isPalindrome([1,1,2,1].linkedList))
