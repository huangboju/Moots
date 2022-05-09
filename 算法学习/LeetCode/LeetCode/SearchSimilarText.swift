//
//  SearchSimilarText.swift
//  LeetCode
//
//  Created by jourhuang on 2021/3/25.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

//现有一个英文词库，要求给定一个输入，返回词库中与这个输入最相似的词，不要求语义相似。
//词库：abstract",default",goto",null",switch",boolean",do",if",package",synchronzed",break",double",implements",private",this",byte",else",import",protected",throw",case",extends",instanceof",public",transient",catch",false",int",return",true",char",final",interface",short",try",class",finally",long",static",void",float",native",volatile",continue",for",new",super",while",assert",enum
//相似：最长最多

func searchSimilarText(_ input: String) -> String {
    var maxCount = 0
    var result = ""
    
    for text in Thesaurus.texts {
        if text.contains(input) {
            return text
        }
        var count = 0
        for char in text {
            if input.contains(char) {
                count += 1
            }
        }
        if count > maxCount {
            result = text
            maxCount = count
        }
    }
    
    return result
}

struct Thesaurus {
    static let texts = [
        "abstract",
        "default",
        "goto",
        "null",
        "switch",
        "boolean",
        "do",
        "if",
        "package",
        "synchronzed",
        "break",
        "double",
        "implements",
        "private",
        "this",
        "byte",
        "else",
        "import",
        "protected",
        "throw",
        "case",
        "extends",
        "instanceof",
        "public",
        "transient",
        "catch",
        "false",
        "int",
        "return",
        "true",
        "char",
        "final",
        "interface",
        "short",
        "try",
        "class",
        "finally",
        "long",
        "static",
        "void",
        "float",
        "native",
        "volatile",
        "continue",
        "for",
        "new",
        "super",
        "while",
        "assert",
        "enum"
    ]
}
