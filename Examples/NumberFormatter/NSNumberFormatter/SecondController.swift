//
//  SecondController.swift
//  NSNumberFormatter
//
//  Created by 伯驹 黄 on 2016/11/2.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class SecondController: UIViewController, HeaderViewPresenter {
    
    var textField: UITextField?
    var displayLabel: UILabel? 
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: self.view.frame.height - 313, width: self.view.frame.width, height: 264))
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var data: [Item] = [
        Item(methodName: "bankCardNumber", desc: "分割16位银行卡号"),
        Item(methodName: "currencyDisplay", desc: "货币显示"),
        Item(methodName: "accurateDisplay", desc: "带,分隔的精确显示"),
        Item(methodName: "changeDetails", desc: "微信零钱明细"),
        Item(methodName: "percent", desc: "百分数"),
        Item(methodName: "customizingGroupingSeparator", desc: "自定义分隔符"),
        Item(methodName: "currencyStrToNumber", desc: "货币字符串转数字")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(tableView)
        
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "NumberFormatter使用"
        navigationItem.prompt = "测试"
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        
        setupHeaderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SecondController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}

extension SecondController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item =  data[indexPath.row]
        cell.textLabel?.text = item.methodName
        cell.detailTextLabel?.text = item.desc
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = data[indexPath.row]
        navigationItem.title = item.methodName
        navigationItem.prompt = item.desc
        print("🍀🍀🍀🍀🍀\(item.methodName)🍀🍀🍀🍀🍀")
        perform(Selector(item.methodName))
        print("\n*****************************************************\n")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension SecondController {
    
    var inputNumber: NSDecimalNumber {
        return NSDecimalNumber(string: textField?.text)
    }
    
    var isNaN: Bool {
        return inputNumber.doubleValue.isNaN
    }
    
    func bankCardNumber() {
        let numberFormatter = NumberFormatter()
        // 分隔位数,会受numberStyle的影响，currency，decimal是3位
        numberFormatter.groupingSize = 4
        // 会受numberStyle的影响，currency，decimal是true
        numberFormatter.usesGroupingSeparator = true
        // 分隔符号
        numberFormatter.groupingSeparator = " "
        let cardNumber: Int64 = isNaN ?
                                8888888888888888 :
                                inputNumber.int64Value
        let number = NSNumber(value: cardNumber)
        displayLabel?.text = numberFormatter.string(from: number)
    }
    
    func currencyDisplay() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.currencySymbol = "" // 注释这一句前面可以有货币符号
        let n: NSNumber = isNaN ?
                          1000 :
                          inputNumber
        displayLabel?.text = numberFormatter.string(from: n)
    }
    
    // 从64.01开始，NSNumber(value: 64.01).description得到是这样“64.01000000000001”到“99.01”都是有bug的，可能不准确，请注意。
    func accurateDisplay() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        
        numberFormatter.currencySymbol = ""
        let n: NSNumber = isNaN ?
                          12345.7658 :
                          inputNumber
        // 使用这句去掉分隔符
//        numberFormatter.usesGroupingSeparator = false
        // 这句控制小数点后保留几位, 在currency默认2位decimal默认3
        numberFormatter.maximumFractionDigits = Int.max
        displayLabel?.text = numberFormatter.string(from: n)
    }
    
    func changeDetails() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.currencySymbol = ""
        numberFormatter.negativePrefix = "- "
//        numberFormatter.negativeSuffix = "元"
        let flag = isNaN
        let negativeText = numberFormatter.string(from: flag ? -12345.7658 : inputNumber.multiplying(by: -1))!
        numberFormatter.positivePrefix = "+ "
//        numberFormatter.positiveSuffix = "元"
        let positiveText = numberFormatter.string(from: flag ? 12345.7658 : inputNumber)!
        displayLabel?.text = negativeText + "\n\n" + positiveText
    }
    
    func percent() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.percent
        let n: NSNumber = isNaN ?
            0.121 :
        inputNumber
        numberFormatter.maximumFractionDigits = Int.max
        displayLabel?.text = numberFormatter.string(from: n)
    }
    
    func customizingGroupingSeparator() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let n: NSNumber = isNaN ?
            12345.7658 :
        inputNumber
        numberFormatter.groupingSeparator = "_"
        numberFormatter.maximumFractionDigits = Int.max
        displayLabel?.text = numberFormatter.string(from: n)
    }
    
    func currencyStrToNumber() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        let text = numberFormatter.string(from: inputNumber)
        let str = isNaN ? numberFormatter.currencySymbol + "12,345.76" : text!
        let num = numberFormatter.number(from: str)
        displayLabel?.text = "原字符串：" + str + "\n\n反转数字" + num!.description
    }
}
