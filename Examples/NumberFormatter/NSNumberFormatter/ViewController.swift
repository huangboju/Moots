//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var data: [String] = [
        "numberStyle",
        "locale",
        "generatesDecimalNumbers",
        "formatterBehavior",
        "negativeFormat",
        "textAttributesForNegativeValues",
        "positiveFormat",
        "textAttributesForPositiveValues",
        "allowsFloats",
        "decimalSeparator",
        "alwaysShowsDecimalSeparator",
        "currencyDecimalSeparator",
        "usesGroupingSeparator",
        "groupingSeparator",
        "zeroSymbol",
        "textAttributesForZero",
        "nilSymbol",
        "notANumberSymbol",
        "textAttributesForNotANumber",
        "positiveInfinitySymbol",
        "textAttributesForPositiveInfinity",
        "negativeInfinitySymbol",
        "textAttributesForNegativeInfinity",
        "positivePrefix",
        "positiveSuffix",
        "negativePrefix",
        "negativeSuffix",
        "currencyCode",
        "currencySymbol",
        "internationalCurrencySymbol",
        "percentSymbol",
        "perMillSymbol",
        "minusSign",
        "plusSign",
        "exponentSymbol",
        "groupingSize",
        "secondaryGroupingSize",
        "multiplier",
        "formatWidth",
        "paddingCharacter",
        "paddingPosition",
        "roundingMode",
        "roundingIncrement",
        "minimumIntegerDigits",
        "maximumIntegerDigits",
        "minimumFractionDigits",
        "maximumFractionDigits",
        "minimum",
        "maximum",
        "currencyGroupingSeparator",
        "isLenient",
        "usesSignificantDigits",
        "minimumSignificantDigits",
        "maximumSignificantDigits",
        "isPartialStringValidationEnabled",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = data[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}
