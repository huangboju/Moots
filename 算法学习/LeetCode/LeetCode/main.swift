//
//  main.swift
//  LeetCode
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import Foundation

print(twoSum([2, 7, 11, 15, 0, 9], 9))


print(lengthOfLongestSubstring("ppwwpwkew"))

print("\n\n")

//(0...100).forEach {
//    print($0 & 1)
//}

print(bubbleSort([2, 7, 11, 15, 0, 9]))
//(0...100).forEach {
//    print($0 & 1)
//}



print("🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀")

// 硬币面值预先已经按降序排列
let coinValue = [100, 50, 20, 10, 5, 1]
// 需要找零的面值
let money = 165

makeChange(coinValue, money)


/*
 let n = [1, 4, 7, 9, 2, 31, 21, 13, 12, 6, 8, 9]

 target = 32

 input:
 [
 [1, 4, 7, 9, 2, 8],
 [31],
 [21, 9],
 [13, 12, 6]
 ]
 */

var n = [0,1,0,3,12]

moveZeroes(&n)
print(n)


print("\n🍀🍀🍀 背包问题 I 单次选择+最大体积 🍀🍀🍀")
print(backPack1(11, a: [1, 3, 3, 6, 2, 10]))

print("\n🍀🍀🍀 背包问题 II 单次选择+最大价值 🍀🍀🍀")
let size = [2, 3, 5, 7]
let value = [1, 5, 2, 4]
//print(backPackII(10, size: size, value: value))

print("\n🍀🍀🍀 背包问题 III 重复选择+最大价值 🍀🍀🍀")
//print(backPackIII(10, size: size, value: value))

print("\n🍀🍀🍀 背包问题 IV 重复选择+唯一排列+装满可能性总数 🍀🍀🍀")
//print(backPackIV(7, a: [2, 3, 6, 7]))

print("\n🍀🍀🍀 背包问题 V 单次选择+装满可能性总数 🍀🍀🍀")
//print(backPackV(7, nums: [1, 2, 3, 3, 7]))

print("\n🍀🍀🍀 背包问题 VI 重复选择+唯一排列+装满可能性总数 🍀🍀🍀")
//print(backPackVI(4, nums: [1, 2, 4]))

print("\n\n\n")
print(combinationSum2([10, 2, 7, 6, 5], 11))



print(minSubArrayLen(s: 7, nums: [2,3,1,2,4,3]))


print("merge sort")



print("singleNumber")

print(singleNumber([4,1,2,1,2]))



print("majorityElement")

print(majorityElement([2,2,1,1,1,2,2]))


print("searchMatrix")

print(searchMatrix([
    [1,   4,  7, 11, 15],
    [2,   5,  8, 12, 19],
    [3,   6,  9, 16, 22],
    [10, 13, 14, 17, 24],
    [18, 21, 23, 26, 30]
    ], 5))


var nums1 = [1,2,3,0,0,0]
let nums2 = [2,5,6]
merge(&nums1, 3, nums2, 3)
print(nums1)


print(isPalindrome("`l;`` 1o1 ??;l`"))


print(superEggDrop(1, 2))


print(wordBreak("leetcode", ["leet", "code"]))
compress("aaabbccc")


print(fractionToDecimal(2, 1))


var arr = [1,2,3,4,5,6,7]
rotate(&arr, 3)
print(arr)

print(maxProduct([2,3,-2,4]))

print(productExceptSelf([1,2,3,4]))

print(findKthLargest([3,2,1,5,6,4], 2))


print(kthSmallest([
    [ 1,  5,  9],
    [10, 11, 13],
    [12, 13, 15]
    ], 8))

//print(kthSmallest([[1,2],[1,3]], 2))



print(topKFrequent([-1, -1], 1))

print("\n🍀🍀🍀 maxSlidingWindow 🍀🍀🍀")
print(maxSlidingWindow([1, -1], 1))

print(Solution.calculate("3+2*2"))

print(titleToNumber("A"))

print(fourSumCount([1, 2], [-2,-1], [-1, 2], [0, 2]))


print(largestNumber([10, 2]))

print(maxPoints([[1,1],[3,2],[5,3],[4,1],[2,3],[1,4]]))

print(simplifyPath("/a/./b/../../c/"))


print(restoreIpAddresses("25525511135"))

let head = (0..<10).reversed().reduce(ListNode(0)) { (r, v) -> ListNode in
    let new = ListNode(v)
    new.next = r.val == 0 ? nil : r
    return new
}

print(removeNthFromEnd(head, 3))
