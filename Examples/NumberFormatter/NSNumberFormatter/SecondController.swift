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
        let tableView = UITableView(frame: CGRect(x: 0, y: 160, width: self.view.frame.width, height: self.view.frame.height - 209), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var data: [Item] = [
        Item(methodName: "bankCardNumber", desc: "分割16位银行卡号"),
        Item(methodName: "currencyDisplay", desc: "货币显示"),
        Item(methodName: "accurateDisplay", desc: "带,分隔的精确显示"),
        Item(methodName: "changeDetails", desc: "微信零钱明细")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        
        automaticallyAdjustsScrollViewInsets = false
        title = "NumberFormatter使用"
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        
        setupHeaderView()
        
        view.addSubview(tableView)
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
        let text = data[indexPath.row].methodName
        print("🍀🍀🍀🍀🍀\(text)🍀🍀🍀🍀🍀")
        perform(Selector(text))
        print("\n*****************************************************\n")
    }
}

extension SecondController {
    func bankCardNumber() {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSize = 4
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = " "
        let cardNumber: Int64 = 8888888888888888
        let number = NSNumber(value: cardNumber)
        print(numberFormatter.string(from: number) as Any) // "8888 8888 8888 8888"
    }
    
    func currencyDisplay() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.currencySymbol = "" // 注释这一句前面可以有货币符号
        print(numberFormatter.string(from: 1000) as Any)
    }
    
    // 从64.01开始，NSNumber(value: 64.01).description得到是这样“64.01000000000001”到“99.01”都是有bug的，可能不准确，请注意。
    func accurateDisplay() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.currencySymbol = ""
        let n: NSNumber = 12345.7658
        numberFormatter.minimumFractionDigits = n.description.components(separatedBy: ".").last?.characters.count ?? 0
        print(numberFormatter.string(from: n) as Any) // 12,345.7658
    }
    
    func changeDetails() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.currencySymbol = ""
        numberFormatter.negativePrefix = "- "
//        numberFormatter.negativeSuffix = "元"
        print(numberFormatter.string(from: -12345.7658) as Any) // - 12346
        numberFormatter.positivePrefix = "+ "
//        numberFormatter.positiveSuffix = "元"
        print(numberFormatter.string(from: 12345.7658) as Any) // + 12346
    }
}

class Cell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        detailTextLabel?.textColor = UIColor.gray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame.origin.y = 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Item {
    let methodName: String
    let desc: String
}
