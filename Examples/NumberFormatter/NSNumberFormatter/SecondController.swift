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
        Item(methodName: "currencyStrToNumber", desc: "货币字符串转数字"),
        Item(methodName: "rounding", desc: "取整")
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
        let formatter = NumberFormatter()
        // 分隔位数,会受numberStyle的影响，currency，decimal是3位
        formatter.groupingSize = 4
        // 会受numberStyle的影响，currency，decimal是true
        formatter.usesGroupingSeparator = true
        // 分隔符号
        formatter.groupingSeparator = " "
        let cardNumber: Int64 = isNaN ?
                                8888888888888888 :
                                inputNumber.int64Value
        let number = NSNumber(value: cardNumber)
        displayLabel?.text = formatter.string(from: number)
    }
    
    func currencyDisplay() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.currencySymbol = "" // 注释这一句前面可以有货币符号
        let n: NSNumber = isNaN ?
                          1000 :
                          inputNumber
        displayLabel?.text = formatter.string(from: n)
    }
    
    // 从64.01开始，NSNumber(value: 64.01).description得到是这样“64.01000000000001”到“99.01”都是有bug的，可能不准确，请注意。
    func accurateDisplay() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        
        formatter.currencySymbol = ""
        let n: NSNumber = isNaN ?
                          12345.7658 :
                          inputNumber
        // 使用这句去掉分隔符
//        numberFormatter.usesGroupingSeparator = false
        // 这句控制小数点后保留几位, 在currency默认2位decimal默认3
        formatter.maximumFractionDigits = Int.max
        displayLabel?.text = formatter.string(from: n)
    }
    
    func changeDetails() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.currencySymbol = ""
        formatter.negativePrefix = "- "
//        numberFormatter.negativeSuffix = "元"
        let flag = isNaN
        let negativeText = formatter.string(from: flag ? -12345.7658 : inputNumber.multiplying(by: -1))!
        formatter.positivePrefix = "+ "
//        numberFormatter.positiveSuffix = "元"
        let positiveText = formatter.string(from: flag ? 12345.7658 : inputNumber)!
        displayLabel?.text = negativeText + "\n\n" + positiveText
    }
    
    func percent() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.percent
        let n: NSNumber = isNaN ?
                          0.121 :
                          inputNumber
        formatter.maximumFractionDigits = Int.max
        displayLabel?.text = formatter.string(from: n)
    }
    
    func customizingGroupingSeparator() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        let n: NSNumber = isNaN ?
                          12345.7658 :
                          inputNumber
        formatter.groupingSeparator = "_"
        formatter.maximumFractionDigits = Int.max
        displayLabel?.text = formatter.string(from: n)
    }
    
    func currencyStrToNumber() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let text = formatter.string(from: inputNumber)
        let str = isNaN ? formatter.currencySymbol + "12,345.76" : text!
        let num = formatter.number(from: str)
        displayLabel?.text = "原字符串：" + str + "\n\n反转数字：" + num!.description
    }
    
    /*
        ceiling 回到正无穷。  1.1->2, -1.1->-1
        floor 向负无穷大舍入。  1.1->1, -1.1->-2
        down 向零舍入。  1.99->1, -1.1->-1
        up 从零舍弃。    0.01->1, -1.1->-2
        halfEven 向最接近的整数，或偶数的等距离。   0.5->0, 1.5->2 -0.5->-0, -1.5->-2
        halfDown 向最接近的整数舍入，或如果等距离则向零。   0.5->0, 1.5->1
        halfUp  向最接近的整数舍入，或如果等距离，则离开零。  0.5->1, 1.5->2
     */
    //
    func rounding() {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        let n: NSNumber = isNaN ?
                          1.43 :
                          inputNumber
        displayLabel?.text = "初值：" + n.description + "\n\n取整值:" + formatter.string(from: n)!
    }
}
