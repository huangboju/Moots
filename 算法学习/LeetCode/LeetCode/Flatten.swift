//
//  Flatten.swift
//  LeetCode
//
//  Created by jourhuang on 2021/1/31.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

func flatten(_ root: TreeNode?) {
    var temp = root
    while temp != nil {
        //左子树为 null，直接考虑下一个节点
        if temp?.left != nil {
            // 找左子树最右边的节点
            var pre = temp?.left
            while pre?.right != nil {
                pre = pre?.right
            }
            //将原来的右子树接到左子树的最右边节点
            pre?.right = temp?.right
            // 将左子树插入到右子树的地方
            temp?.right = temp?.left
            temp?.left = nil
            
        }
        // 考虑下一个节点
        temp = temp?.right
    }
}
