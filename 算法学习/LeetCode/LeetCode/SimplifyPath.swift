//
//  SimplifyPath.swift
//  LeetCode
//
//  Created by xiAo_Ju on 2020/3/23.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import Foundation

// "/a/./b/../../c/"

//在 Unix 风格的文件系统中，一个点（.）表示当前目录本身；此外，两个点 （..） 表示将目录切换到上一级（指向父目录）；两者都可以是复杂相对路径的组成部分。更多信息请参阅：Linux / Unix中的绝对路径 vs 相对路径
//
//请注意，返回的规范路径必须始终以斜杠 / 开头，并且两个目录名之间必须只有一个斜杠 /。最后一个目录名（如果存在）不能以 / 结尾。此外，规范路径必须是表示绝对路径的最短字符串。

func simplifyPath(_ path: String) -> String {
     var stack = [String]()
     let paths = path.components(separatedBy: "/")
     for path in paths {
         guard path != "." else {
             continue
         }

        if path == ".." {
            if stack.count > 0 {
                stack.removeLast()
            }
        } else if path != "" {
            stack.append(path)
        }
    }

    let result = stack.reduce("") { (total, dir) in
        return "\(total)/\(dir)"
    }

    return result.isEmpty ? "/": result
}
