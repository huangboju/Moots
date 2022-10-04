//
//  FindKthLargest.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2019/5/14.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/explore/featured/card/top-interview-quesitons-in-2018/266/heap-stack-queue/1154/

//
//在未排序的数组中找到第 k 个最大的元素。请注意，你需要找的是数组排序后的第 k 个最大的元素，而不是第 k 个不同的元素。
//
//示例 1:
//
//输入: [3,2,1,5,6,4] 和 k = 2
//输出: 5
//示例 2:
//
//输入: [3,2,3,1,2,4,5,5,6] 和 k = 4
//输出: 4
//说明:
//
//你可以假设 k 总是有效的，且 1 ≤ k ≤ 数组的长度。

func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
    if nums.count == 1 {
        return nums[0]
    }
    let result = nums.sorted(by: >)
    return result[k - 1]
}

class FindKthLargest {
    var nums:[Int]!
    func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
        self.nums = nums
        let res = quickSelect(0, nums.count-1, nums.count - k)
        return res
    }
    
    func quickSelect(_ left: Int, _ right:Int, _ index:Int) -> Int {
        //! 找到分区点
        let q = randomPartition(left,right)
        if q == index {
            return nums[q]
        } else {
            return q < index ? quickSelect(q+1, right, index) : quickSelect(left, q-1, index)
        }
        
    }
    //! 以 区间最后一个元素为锚点，依次进行比对分割，左侧比锚点小，右侧比锚点大
    func randomPartition(_ left: Int, _ right:Int) -> Int {
        if left >= right {
            return left
        }
        //! 参考值
        let x = nums[right]
        //! 分区边界, i 是第一个不小于 x 的坐标，也就是左边界
        var i = left
        for j in left..<right {
            if nums[j] < x {
                nums.swapAt(i, j)
                i += 1
            }
        }
        //! 最后 将 参考值 替换
        nums.swapAt(i, right)
        return i
    }
}

// https://leetcode.cn/problems/sort-an-array/solution/912-pai-xu-shu-zu-by-duanyutian-grh9/
class QuickSort {
    func sortArray(_ nums: [Int]) -> [Int] {
        var arr = nums
        quick_sort(&arr, 0, arr.count-1)
        return arr
    }
    
    func quick_sort(_ nums:inout [Int], _ left:Int, _ right : Int) {
        if left >= right {
            return
        }
        let point = partitin(&nums, left, right)
        quick_sort(&nums, left, point-1)
        quick_sort(&nums, point+1,right)
    }
    
    func partitin(_ nums:inout [Int], _ left:Int, _ right : Int) -> Int {
        let randomIndex = Int.random(in: left...right)
        let pivot = nums[randomIndex]
        nums.swapAt(right, randomIndex)
        var i = left
        for j in left..<right {
            if nums[j] <= pivot {
                if i != j {
                    nums.swapAt(i, j)
                }
                
                i += 1
            }
        }
        nums.swapAt(i, right)
        return i
    }
}

