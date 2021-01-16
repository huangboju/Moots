//
//  IsSymmetric.swift
//  LeetCode
//
//  Created by jourhuang on 2021/1/3.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation


public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}


class SolutionSymmetric {
    // https://leetcode-cn.com/problems/symmetric-tree/
    func isSymmetric(_ root: TreeNode?) -> Bool {
        return isEqual(root?.left, root?.right)
    }
    
    func isEqual(_ left: TreeNode?, _ right: TreeNode?) -> Bool {
        if left == nil && right == nil {
            return true
        }
        if left == nil || right == nil {
            return false
        }
        if left?.val != right?.val {
            return false
        }
        return isEqual(left?.left, right?.right) && isEqual(left?.right, right?.left)
    }
    
    // https://leetcode-cn.com/problems/binary-tree-level-order-traversal/
    // DFS:
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else { return [] }
        var res = [[Int]]()
        level(root, 0, &res)
        return res
    }
    
    func level(_ t: TreeNode?, _ l: Int, _ res: inout [[Int]]) {
        if res.count == l { res.append([]) }
        if let v = t?.val {
            res[l].append(v)
        }
        if let left = t?.left {
            level(left, l + 1, &res)
        }
        if let right = t?.right {
            level(right, l + 1, &res)
        }
    }
    
    // BFS:
    //     func levelOrder(_ root: TreeNode?) -> [[Int]] {
    //        guard let root = root else { return [] }
    //        var result = [[Int]]()
    //        var queue = [root]
    //
    //        while !queue.isEmpty {
    //            var row: [Int] = []
    //            for _ in 0 ..< queue.count {
    //                let first = queue.removeFirst()
    //                row.append(first.val)
    //                if let left = first.left {
    //                    queue.append(left)
    //                }
    //                if let right = first.right {
    //                    queue.append(right)
    //                }
    //            }
    //            result.append(row)
    //        }
    //
    //        return result
    //     }
    
    // https://leetcode-cn.com/problems/binary-tree-zigzag-level-order-traversal/
    func zigzagLevelOrder(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else { return [] }
        var result = [[Int]]()
        var queue = [root]
        
        while !queue.isEmpty {
            var row: [Int] = []
            for _ in 0 ..< queue.count {
                let first = queue.removeFirst()
                row.append(first.val)
                if let left = first.left {
                    queue.append(left)
                }
                if let right = first.right {
                    queue.append(right)
                }
            }
            if result.count % 2 != 0 {
                row.reverse()
            }
            result.append(row)
        }
        return result
    }
    
    func inorderTraversal(_ root: TreeNode?) -> [Int] {
        var node = root
        var stack: [TreeNode] = []
        var result: [Int] = []
        while true {
            if node != nil {
                stack.append(node!)
                node = node!.left
            } else if stack.isEmpty {
                return result
            } else {
                node = stack.popLast()
                result.append(node!.val)
                node = node?.right
            }
        }
        return result
    }
    
    //    func inorderTraversal(_ root: TreeNode?) -> [Int] {
    //        var result: [Int] = []
    //        inorder(root, &result)
    //        return result
    //    }
    //
    //    func inorder(_ root: TreeNode?, _ result: inout [Int]) {
    //        guard let root = root else {
    //            return
    //        }
    //        inorder(root.left, &result)
    //        result.append(root.val)
    //        inorder(root.right, &result)
    //    }
    
    // https://leetcode-cn.com/problems/same-tree/
    func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
        if p == nil && q == nil {
            return true
        }
        if p == nil || q == nil {
            return false
        }
        if p?.val != q?.val {
            return false
        }
        return isSameTree(p?.left, q?.left) && isSameTree(p?.right, q?.right)
    }
    
    func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        let left = maxDepth(root.left)
        let right = maxDepth(root.right)
        return max(left, right) + 1
    }
    
    func levelOrderBottom(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else {
            return []
        }
        var result: [[Int]] = []
        var queue: [TreeNode] = [root]
        
        while !queue.isEmpty {
            var row: [Int] = []
            for _ in 0 ..< queue.count {
                let first = queue.removeFirst()
                row.append(first.val)
                if let left = first.left {
                    queue.append(left)
                }
                if let right = first.right {
                    queue.append(right)
                }
            }
            result.append(row)
        }
        
        return result.reversed()
    }
    
    // https://leetcode-cn.com/problems/convert-sorted-array-to-binary-search-tree/
    func sortedArrayToBST(_ nums: [Int]) -> TreeNode? {
        func dfs(_ nums: [Int], _ leftIndex: Int, _ rightIndex: Int) -> TreeNode? {
            if leftIndex > rightIndex {
                return nil
            }
            // 以升序数组的中间元素作为根节点 root。
            let mid = leftIndex + (rightIndex - leftIndex) / 2
            let root = TreeNode(nums[mid])
            // 递归的构建 root 的左子树与右子树。
            root.left = dfs(nums, leftIndex, mid - 1)
            root.right = dfs(nums, mid + 1, rightIndex)
            return root
        }
    
        return dfs(nums, 0, nums.count - 1)
    }
}
