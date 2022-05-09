//
//  LRUCache.swift
//  DataStructures
//
//  Created by xiAo_Ju on 2020/3/20.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import Foundation

class LRUCache {

    class ListNode {
        var key: Int
        var value: Int

        var pre: ListNode?
        var next: ListNode?
        init(_ key: Int, _ value: Int) {
            self.key = key
            self.value = value
        }
    }

    var capacity = 0
    var headNode = ListNode(0, 0)
    var tailNode = ListNode(0, 0)
    var dict = [Int: ListNode]()


    init(_ capacity: Int) {
        self.capacity = capacity
        headNode.next = tailNode
        tailNode.pre = headNode
    }
    
    func moveToTail(_ node: ListNode) {
        let preNode = node.pre
        let nextNode = node.next
        preNode?.next = nextNode
        nextNode?.pre = preNode

        let lastNode = tailNode.pre
        lastNode?.next = node
        node.pre = lastNode
        node.next = tailNode
        tailNode.pre = node
    }
    
    func addNewNode(_ key: Int, _ value: Int) {
        let newNode = ListNode(key, value)
        let lastNode = tailNode.pre
        lastNode?.next = newNode
        newNode.pre = lastNode
        newNode.next = tailNode
        tailNode.pre = newNode
        dict[key] = newNode
    }
    
    func removeFirstNode() {
        let oldNode = headNode.next
        let oldKey = oldNode?.key
        headNode.next = oldNode?.next
        oldNode?.next?.pre = headNode
        if let temp = oldKey {
            dict[temp] = nil
        }
    }

    func get(_ key: Int) -> Int {
        guard let nodeExisted = dict[key] else {
            return -1
        }
        moveToTail(nodeExisted)
        return nodeExisted.value
    }

    func put(_ key: Int, _ value: Int) {
        // is existed
        if let nodeExisted = dict[key] {
            nodeExisted.value = value
            moveToTail(nodeExisted)
        } else {
            if capacity == 0 {
                removeFirstNode()
            } else {
                capacity -= 1
            }
            addNewNode(key, value)
        }
    }
}
