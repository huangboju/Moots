//
//  SecondController.swift
//  LazyLoad
//
//  Created by 伯驹 黄 on 2016/10/8.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class SecondController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let n = NSNumber(value: 0.58)
        let a = n.description.add(n: "5.4").sub(n: 1).div(n: 10)
        print("a=" + a.description)
        
        let b = getFormatAmount(values: 100000000)
        print("default=" + b)
        
        let c = getFormatAmount(type: .large,values: 100, 45000)
        print("large=" + c)
        
        let d = getFormatAmount(type: .percent,values: 100, 45.8)
        print("percent=" + d)
        
        let e = getFormatAmount(type: .double,values: 100, 45.89)
        print("percent=" + e)
        
        let f = getFormatAmount(type: .float,values: 100, 45.8999)
        print("percent=" + f)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

enum FormatType {
    case `default`, large, percent, double, float
}
// FIXME: 优化方法
func getFormatAmount<T: CustomStringConvertible>(type: FormatType = .default, separator: String? = nil, values: T..., endStr: String = "", startStr: String = "") -> String {
    var sum = "1"
    for num in values {
        sum = sum.mul(n: num.description)
    }
    let num = NSDecimalNumber(string: sum)
    let amount = num.dividing(by: 100)
    let formatter = NumberFormatter()
    switch type {
    case .default:
        // http://blog.csdn.net/yan520521/article/details/43114943
        formatter.numberStyle = NumberFormatter.Style.decimal
        if separator != nil {
            formatter.groupingSeparator = separator
        }
        // formatter.string(from: amount) 会四舍五入
        return startStr + formatter.string(from: amount)! + endStr
    case .large:
        formatter.numberStyle = NumberFormatter.Style.decimal
        let str = formatter.string(from: amount.dividing(by: 10000))!
        return str.contains(".") ? formatter.string(from: amount)! + " 元" : str + " 万元"
    case .percent:
        return startStr + "\(sum.div(n: 100))%" + endStr
    case .double:
        formatter.numberStyle = NumberFormatter.Style.currency // 用这个为了解决没有小数点
        formatter.currencySymbol = "" // 去掉货币符号
        let string = formatter.string(from: amount)?.trimmingCharacters(in: .whitespaces) ?? "0.00"
        return startStr + string + endStr
    case .float:
        return startStr + String(format: "%.1f", Double(sum.div(n: 100))!) + endStr
    }
}


extension String {
    func add<T: CustomStringConvertible>(n: T) -> String {
        return NSDecimalNumber(string: self).adding(NSDecimalNumber(string: n.description)).description
    }

    func sub<T: CustomStringConvertible>(n: T) -> String {
        return NSDecimalNumber(string: self).subtracting(NSDecimalNumber(string: n.description)).description
    }

    func mul<T: CustomStringConvertible>(n: T) -> String {
        return NSDecimalNumber(string: self).multiplying(by: NSDecimalNumber(string: n.description)).description
    }
    
    func div<T: CustomStringConvertible>(n: T) -> String {
        return NSDecimalNumber(string: self).dividing(by: NSDecimalNumber(string: n.description)).description
    }
}
