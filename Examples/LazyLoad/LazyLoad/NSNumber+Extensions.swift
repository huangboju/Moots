//
//  NSNumber+Extensions.swift
//  LazyLoad
//
//  Created by 伯驹 黄 on 2016/10/12.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Foundation

infix operator --
infix operator ++

public extension NSNumber {
    
    ///Returns the number with the default currency of the device
    ///ex: $3.00
    func _currencyString(maxFractionDigits: NSInteger) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.maximumFractionDigits = maxFractionDigits
        return formatter.string(from: self)
    }
}

///Subtract two numbers
public func - (first: NSNumber, second:NSNumber) -> NSNumber {
    let value = first.doubleValue - second.doubleValue
    return NSNumber(value: value)
}

///Add two numbers
public func + (first: NSNumber, second:NSNumber) -> NSNumber {
    let value = first.doubleValue + second.doubleValue
    return NSNumber(value: value)
}

///Multiply two numbers
public func * (first: NSNumber, second:NSNumber) -> NSNumber {
    let value = first.doubleValue * second.doubleValue
    return NSNumber(value: value)
}

///Divide two numbers
public func / (first: NSNumber, second:NSNumber) -> NSNumber {
    let value = first.doubleValue / second.doubleValue
    return NSNumber(value: value)
}

///Postfix decrement two numbers
public postfix func -- (first: NSNumber) -> NSNumber {
    let value = first.floatValue - 1.0
    return NSNumber(value: value)
}

///Postfix increment two numbers
public postfix func ++ (first: NSNumber) -> NSNumber {
    let value = first.floatValue + 1.0
    return NSNumber(value: value)
}
