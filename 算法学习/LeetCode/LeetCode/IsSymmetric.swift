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
    
    // https://leetcode-cn.com/problems/binary-tree-inorder-traversal/?utm_source=LCUS&utm_medium=ip_redirect&utm_campaign=transfer2china
    func inorderTraversal(_ root: TreeNode?) -> [Int] {
        guard let root = root else { return [] }
        
        var result: [Int] = []
        result += inorderTraversal(root.left)
        result.append(root.val)
        result += inorderTraversal(root.right)
        
        return result
    }

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
    
    // https://leetcode-cn.com/problems/maximum-depth-of-binary-tree/
    func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        let left = maxDepth(root.left)
        let right = maxDepth(root.right)
        return max(left, right) + 1
    }
    
    // https://leetcode-cn.com/problems/binary-tree-level-order-traversal-ii/
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
    
    // https://leetcode-cn.com/problems/convert-sorted-list-to-binary-search-tree/
    func sortedListToBST(_ head: ListNode?) -> TreeNode? {
        func helper(_ nums: [Int], _ leftIndex: Int, _ rightIndex: Int) -> TreeNode? {
            if leftIndex > rightIndex {
                return nil
            }
            let mid = leftIndex + (rightIndex - leftIndex) / 2
            let root = TreeNode(nums[mid])
            root.left = helper(nums, leftIndex, mid - 1)
            root.right = helper(nums, mid + 1, rightIndex)
            return root
        }
        
        var nums: [Int] = []
        var next = head
        while let node = next {
            nums.append(node.val)
            next = next?.next
        }
        return helper(nums, 0, nums.count - 1)
    }
    
    // https://leetcode-cn.com/problems/balanced-binary-tree/
    func isBalanced(_ root: TreeNode?) -> Bool {
        func maxDepth(_ root:TreeNode?) -> Int {
            guard let root = root else {
                return 0
            }
            return max(maxDepth(root.left), maxDepth(root.right)) + 1
        }

        guard let root = root else {
            return true
        }

        return isBalanced(root.left) && isBalanced(root.right) && abs(maxDepth(root.left) - maxDepth(root.right))<=1
    }
    
    // https://leetcode-cn.com/problems/path-sum/
    func hasPathSum(_ root: TreeNode?, _ sum: Int) -> Bool {
        guard let root = root else {
            return false
        }
        if root.left == nil && root.right == nil {
            return root.val == sum
        }
        return hasPathSum(root.left, sum - root.val) || hasPathSum(root.right, sum - root.val)
    }
    
    // https://leetcode-cn.com/problems/path-sum-ii/
    //    func pathSum2(_ root: TreeNode?, _ sum: Int) -> [[Int]] {
    //        var result = [[Int]]()
    //        var path = [Int]()
    //        func dfs(_ root: TreeNode?, _ sum: Int) {
    //            guard let root = root else {
    //                return
    //            }
    //
    //            let target = sum - root.val
    //            path.append(root.val)
    //
    //            if root.left == nil && root.right == nil {
    //                if target == 0 {
    //                    result.append(path)
    //                }
    //            } else {
    //                dfs(root.left, target)
    //                dfs(root.right, target)
    //            }
    //
    //            path.removeLast()
    //        }
    //
    //        dfs(root, sum)
    //
    //        return result
    //    }
    
    // bfs
    func pathSum2(_ root: TreeNode?, _ sum: Int) -> [[Int]] {
        var result = [[Int]]()
        var queue: [(node: TreeNode?, path: [Int], pathSum: Int)] = [(root, [], 0)]
        while !queue.isEmpty {
            let (root, path, pathSum) = queue.removeFirst()
            guard let node = root else {
                continue
            }
            if node.left == nil && node.right == nil {
                if node.val + pathSum == sum {
                    result.append(path + [node.val])
                }
            }
            queue.append((node.left, path + [node.val], pathSum + node.val))
            queue.append((node.right, path + [node.val], pathSum + node.val))
        }
        return result
    }
}
