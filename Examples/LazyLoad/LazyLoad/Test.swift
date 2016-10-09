//
//  Test.swift
//  LazyLoad
//
//  Created by 伯驹 黄 on 2016/10/8.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//


func SwapTwoValues<T> (a: inout T, b: inout T) {
    (a, b) = (b, a)
}

struct Stack<Element> {
    
    var items = [Element]()
    mutating func push(item:Element){
        items.append(item)
    }
    
    mutating func pop()->Element{
        return items.removeLast()
    }
}

extension Stack{
    //给泛型Stack扩展一个计算型属性topItem，返回最上面的item
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

class SomeClass {
    
}

protocol SomeProtocol {
    
}


func somFuntion<C: SomeClass, P: SomeProtocol>(someClass: C, someProtocol: P){
    
}

func findStrInArray(_ array: [String], strToFind: String) -> Int? {
    for  (index, value) in array.enumerated() {
        if strToFind == value {
            return index
        }
    }
    return nil
}

func findIndex <S: Equatable> (_ array: [S], valueToFind: S) -> Int? {
    for  (index,value) in array.enumerated() {
        if value == valueToFind { //如果没指定S：Equatable 这句话会编译不通过
            return index
        }
    }
    return nil
}

protocol Container {
    associatedtype itemType //声明一个关联类型
    mutating func append(item: itemType)
    var count: Int { get }
    subscript(i: Int) -> itemType { get }
}

struct intStack: Container {
    // IntStack 的原始实现部分
    var items = [Int]()
    
    mutating func push(item: Int) {
        items.append(item)
    }
    
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    // Container 协议的实现部分

    mutating func append(item: Int) {
        self.push(item: item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

struct genericStack<Element>: Container {
    // genericStack<Element> 的原始实现部分
    var items = [Element]()
    
    mutating func push(item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }

    mutating func append(item: Element) {
        self.push(item: item)
    }
    
    var count: Int {
        return items.count
    }
   
    subscript(i: Int) -> Element {
        return items[i]
    }
}


func allItemsMatch<C1: Container, C2: Container>(someContainer: C1, _ anotherContainer: C2) -> Bool where C1.itemType == C2.itemType, C1.itemType: Equatable {
    
    if someContainer.count != anotherContainer.count {
        return false
    }
    
    for i in 0...someContainer.count - 1 {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
    return true
}

func test() {
    var stackOfStrings = genericStack<String>()
    stackOfStrings.append(item: "uno")
    stackOfStrings.append(item: "dos")
    stackOfStrings.append(item: "tres")
    
    var arrayOfStrings = ["uno", "dos", "tres"] //array类型的满足Container类型，参考上面的extension Array
    
//    if allItemsMatch(someContainer: stackOfStrings, arrayOfStrings) {
//        print("All items match.")
//    } else {
//        print("Not all items match.")
//    }
}




