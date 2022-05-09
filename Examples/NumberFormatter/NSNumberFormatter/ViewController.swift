//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

// 官方接口参考 https://developer.apple.com/reference/foundation/numberformatter

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
        title = "NumberFormatter"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        barButton()
        
//        button()
    }
    
    func barButton() {
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.badgeValue = "1"
        navigationItem.leftBarButtonItem?.badgeMinSize = 1
        navigationItem.leftBarButtonItem?.badgeBGColor = UIColor.red
    }

    @objc func runloop()  {
        print("😁")
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
        perform(#selector(runloop), with: self, afterDelay: 0, inModes: [RunLoop.Mode.default])
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = data[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let text = data[indexPath.row]
        print("🍀🍀🍀🍀🍀\(text)🍀🍀🍀🍀🍀")
        perform(Selector(text))
        print("\n*****************************************************\n")
    }
}

extension ViewController {
    

    /*
     *  default: none
     *  desc:  数字的风格
     */

    @objc func numberStyle() {
        let number = NSNumber(value: 1234567.8369)
        let number1 = NSNumber(value: 1234567.4344)
        
        let dict = [
            "none(四舍五入的整数)": NumberFormatter.Style.none,
            "decimal(小数形式)": NumberFormatter.Style.decimal,
            "currency(货币形式)": NumberFormatter.Style.currency,
            "percent(百分数形式)": NumberFormatter.Style.percent,
            "scientific(科学计数)": NumberFormatter.Style.scientific,
            "spellOut(朗读形式)": NumberFormatter.Style.spellOut,
            "ordinal(序数形式)": NumberFormatter.Style.ordinal,
            "currencyISOCode(货币形式)": NumberFormatter.Style.currencyISOCode,
            "currencyPlural(货币形式)": NumberFormatter.Style.currencyPlural,
            "currencyAccounting(会计计数)": NumberFormatter.Style.currencyAccounting
        ]

        for item in dict {
            print("⚠️\(item.key)")
            let str = NumberFormatter.localizedString(from: number, number: item.value)
            print(str, number, "\n")
            let str1 = NumberFormatter.localizedString(from: number1, number: item.value)
            print(str1, number1, "\n")
        }
    }
    
    //  Locale Identifiers  https://gist.github.com/jasef/337431c43c3addb2cbd5eb215b376179
    /*
     *  default: Locale.current
     *  desc:  设置地区，会影响currencySymbol，internationalCurrencySymbol
     */
    
    // open var locale: Locale!
    @objc func locale() {
        let formatter = NumberFormatter()
        print(formatter.locale)
        formatter.locale = Locale(identifier: "fr_FR")
        print(formatter.currencySymbol) // €
        formatter.locale = Locale(identifier: "en_US")
        print(formatter.currencySymbol) // $
    }
    
    
    /*
     * default: false
     * desc:  控制这个func number(from string: String) -> NSNumber?的返回值是
     *        false是NSNumber
     *        true是NSDecimalNumber
     */
    
    // open var generatesDecimalNumbers: Bool
    @objc func generatesDecimalNumbers() {
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = true
        let str = numberFormatter.number(from: "1234.56878")
        if str!.isMember(of: NSNumber.self) {
            print("number")
        } else if str!.isMember(of: NSDecimalNumber.self) {
            print("DecimalNumber")
        }
    }
    
    /*
     *  default: Behavior
     *  desc: ??? 接收器的格式化器行为。
     */
    
    // open var formatterBehavior: NumberFormatter.Behavior
    @objc func formatterBehavior() {
        let formatter = NumberFormatter()
        print(formatter.formatterBehavior)
    }
    
    /*
     *  default: #
     *  desc: 负数的格式，有点类似时间格式化
     */
    
    // open var negativeFormat: String!
    @objc func negativeFormat() {
        let formatter = NumberFormatter()
        print(formatter.negativeFormat)
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.string(from: -70.00)!) // -$70.00
        formatter.negativeFormat = "¤-#,##0.00"
        print(formatter.string(from: -70.00)!) //$-70.00
    }
    
    
    /*
     *  default: nil
     *  desc: ???  用于显示负值的文本属性。
     */
    
    // open var textAttributesForNegativeValues: [String : Any]?
    @objc func textAttributesForNegativeValues() {
        let formatter = NumberFormatter()
        print(formatter.textAttributesForNegativeValues as Any)
    }
    
    
    /*
     *  default: #
     *  desc: 正数的格式，有点类似时间格式化
     */
    
    // open var positiveFormat: String!
    @objc func positiveFormat() {
        let formatter = NumberFormatter()
        print(formatter.positiveFormat)
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.string(from: 70.00)!) // $70.00
        formatter.positiveFormat = "+¤#,##0.00"
        print(formatter.string(from: 70.00)!) //+$70.00
    }
    
    
    /*
     *  default: nil
     *  desc: ??? 用于显示正值的文本属性。
     */
    
    // open var textAttributesForPositiveValues: [String : Any]?
    @objc func textAttributesForPositiveValues() {
        let formatter = NumberFormatter()
        print(formatter.textAttributesForPositiveValues as Any)
    }
    
    
    
    /*
     *  default: true
     *  desc: 是否允许浮点数
     */
    
    // open var allowsFloats: Bool
    @objc func allowsFloats() {
        let formatter = NumberFormatter()
        let str = formatter.number(from: "1237868794.56878")
        print(str!) // 1237868794.56878
        formatter.allowsFloats = false
        let str1 = formatter.number(from: "1237868794.56878")
        print(str1 as Any) // nil
    }
    
    
    /*
     *  default: '.'
     *  desc: NumberFormatter.Style.decimal的分隔标准
     */
    
    // open var decimalSeparator: String!
    @objc func decimalSeparator() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.decimalSeparator)
        formatter.decimalSeparator = ","
        let str = formatter.number(from: "1237868,79456878")
        print(str!) // 1237868.79456878
    }
    
    
    
    /*
     *  default: false
     *  desc: 确定接收器是否始终显示小数分隔符，即使对于整数也是如此。
     */
    
    // open var alwaysShowsDecimalSeparator: Bool
    @objc func alwaysShowsDecimalSeparator() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.alwaysShowsDecimalSeparator)
        formatter.alwaysShowsDecimalSeparator = true
        let str = formatter.string(from: 14321423)
        print(str!) // 14,321,423.
    }
    
    /*
     *  default: '.'
     *  desc: 小数点替代符
     */
    
    // open var currencyDecimalSeparator: String!
    @objc func currencyDecimalSeparator() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.currencyDecimalSeparator)
        let str = formatter.string(from: 14321423.123)
        print(str!) //  $14,321,423.12
        formatter.currencyDecimalSeparator = "_"
        let str1 = formatter.string(from: 14321423.123)
        print(str1!) // $14,321,423_12
    }
    
    
    
    /*
     *  default: true
     *  desc: 是否使用分隔符
     */
    
    // open var usesGroupingSeparator: Bool
    @objc func usesGroupingSeparator() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.usesGroupingSeparator)
        let str = formatter.string(from: 14321423.123)
        print(str!) //  $14,321,423.12
        formatter.usesGroupingSeparator = false
        let str1 = formatter.string(from: 14321423.123)
        print(str1!) // $14321423.12
    }
    
    
    /*
     *  default: ','
     *  desc:  NumberFormatter.Style.decimal 的分隔符
     */
    
    // open var groupingSeparator: String!
    @objc func groupingSeparator() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.groupingSeparator)
        let str = formatter.string(from: 14321423.123)
        print(str!) //  $14,321,423.123
        formatter.groupingSeparator = "*"
        let str1 = formatter.string(from: 14321423.123)
        print(str1!) // $14*321*423.123
    }
    
    
    /*
     *  default: nil
     *  desc: 数字0的替换符号
     */
    
    // open var zeroSymbol: String?
    @objc func zeroSymbol() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.zeroSymbol as Any)
        let str = formatter.string(from: 0)
        print(str!) //  0
        formatter.zeroSymbol = "*"
        let str1 = formatter.string(from: 0)
        print(str1!) // *
    }
    
    
    
    /*
     *  default: nil
     *  desc: ??? 接收器用于显示零值的属性字符串。
     */
    
    // open var textAttributesForZero: [String : Any]?
    @objc func textAttributesForZero() {
        let formatter = NumberFormatter()
        print(formatter.textAttributesForZero as Any)
    }
    
    
    /*
     *  default: nil
     *  desc: ??? 接收器用来表示空值的字符串。
     */
    
    // open var nilSymbol: String
    @objc func nilSymbol() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.nilSymbol)
        formatter.nilSymbol = ">"
        let str = formatter.number(from: "--")
        print(str as Any)
    }
    
    
    
    /*
     *  default: nil
     *  desc: ??? 用于显示nil符号的文本属性。
     */
    
    // open var textAttributesForNil: [String : Any]?
    @objc func textAttributesForNil() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.textAttributesForNil as Any)
    }
    
    
    /*
     *  default: NaN
     *  desc: ??? 接收器用来表示NaN（“不是数字”）的字符串。 非数字符号 "NaN"
     */
    
    // open var notANumberSymbol: String!
    
    @objc func notANumberSymbol() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.notANumberSymbol)
    }
    
    
    /*
     *  default: nil
     *  desc: ??? 用于显示NaN（“不是数字”）字符串的文本属性。
     */
    
    // open var textAttributesForNotANumber: [String : Any]?
    
    @objc func textAttributesForNotANumber() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.textAttributesForNotANumber as Any)
    }
    
    
    /*
     *  default: +∞
     *  desc: 正无穷符号
     */
    
    // open var positiveInfinitySymbol: String
    @objc func positiveInfinitySymbol() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.positiveInfinitySymbol)
    }
    
    /*
     *  default: nil
     *  desc: ??? 用于显示正无穷大符号的文本属性。
     */
    
    // open var textAttributesForPositiveInfinity: [String : Any]?
    @objc func textAttributesForPositiveInfinity() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.textAttributesForPositiveInfinity as Any)
    }
    
    
    /*
     *  default: -∞
     *  desc: 负无穷
     */
    
    // open var negativeInfinitySymbol: String
    @objc func negativeInfinitySymbol() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.negativeInfinitySymbol)
    }
    
    
    /*
     *  default: nil
     *  desc: ??? 用于显示负无穷大符号的文本属性。
     */
    
    // open var textAttributesForNegativeInfinity: [String : Any]?
    @objc func textAttributesForNegativeInfinity() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.textAttributesForNegativeInfinity as Any)
    }
    
    
    /*
     *  default: ''
     *  desc: 正数的前缀
     */
    
    // open var positivePrefix: String!
    
    @objc func positivePrefix() {
        let formatter = NumberFormatter()
        print(formatter.positivePrefix, "😁")
        let str = formatter.string(from: 123456)
        print(str as Any)
        formatter.positivePrefix = "+" // 123456
        let str1 = formatter.string(from: 123456) // +123456
        print(str1 as Any)
    }
    
    /*
     *  default: ''
     *  desc: 正数的后缀
     */
    
    // open var positiveSuffix: String!
    @objc func positiveSuffix() {
        let formatter = NumberFormatter()
        print(formatter.positiveSuffix, "😁")
        let str = formatter.string(from: 123456)
        print(str as Any) // "123456"
        formatter.positiveSuffix = "🌞"
        let str1 = formatter.string(from: 123456)
        print(str1 as Any) // "123456🌞"
    }
    
    
    
    
    /*
     *  default: '-'
     *  desc: 负数的前缀
     */
    
    // open var negativePrefix: String!
    @objc func negativePrefix() {
        let formatter = NumberFormatter()
        print(formatter.negativePrefix, "😁")
        let str = formatter.string(from: -123456)
        print(str as Any) // -123456
        formatter.negativePrefix = "减号"
        let str1 = formatter.string(from: -123456) // 减号123456
        print(str1 as Any)
    }
    
    
    /*
     *  default: '-'
     *  desc: 负数的后缀
     */
    
    // open var negativeSuffix: String!
    @objc func negativeSuffix() {
        let formatter = NumberFormatter()
        print(formatter.negativeSuffix, "😁")
        let str = formatter.string(from: -123456)
        print(str as Any) // "-123456"
        formatter.negativeSuffix = "🌞"
        let str1 = formatter.string(from: -123456) // "-123456🌞"
        print(str1 as Any) //
    }
    
    
    
    /*
     *  default: USD （应该是根据系统语言变化的）
     *  desc: 货币代码
     */

    // open var currencyCode: String!
    @objc func currencyCode() {
        let formatter = NumberFormatter()
        print(formatter.currencyCode)
    }
    
    
    
    /*
     *  default: $（应该会随系统语言变化）
     *  desc: 货币符号
     */
    
    // open var currencySymbol: String!
    @objc func currencySymbol() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.currencySymbol)
        let str = formatter.string(from: 123456) // $123,456.00
        print(str as Any)
        formatter.currencySymbol = "💵"
        let str1 = formatter.string(from: 123456) // 💵123,456.00
        print(str1 as Any)
    }
    
    
    /*
     *  default: USD (会随语言变化而变化，设置locale也会变化)
     *  desc:
     */
    
    // open var internationalCurrencySymbol: String!
    @objc func internationalCurrencySymbol() {
        let formatter = NumberFormatter()
        //        formatter.locale = Locale(identifier: "de_DE")
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.internationalCurrencySymbol)
        let str = formatter.string(from: 123456)
        print(str as Any)
        let str1 = formatter.string(from: 123456)
        print(str1 as Any)
    }
    
    
    /*
     *  default: %
     *  desc: 百分号，可以自定义
     */
    
    // open var percentSymbol: String!
    @objc func percentSymbol() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.percent
        print(formatter.percentSymbol)
        let str = formatter.string(from: 123456) // 12,345,600%
        print(str as Any)
        formatter.percentSymbol = "😄"
        let str1 = formatter.string(from: 123456) // 12,345,600😄
        print(str1 as Any)
    }
    
    
    /*
     *  default: ‰
     *  desc: 千分号
     */
    
    // open var perMillSymbol: String!
    @objc func perMillSymbol() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.percent
        print(formatter.perMillSymbol)
    }
    
    
    /*
     *  default: -
     *  desc: 减号
     */
    
    //  open var minusSign: String!
    @objc func minusSign() {
        let formatter = NumberFormatter()
        print(formatter.minusSign)
    }
    
    
    
    /*
     *  default: +
     *  desc: 加号
     */
    
    // open var plusSign: String!
    @objc func plusSign() {
        let formatter = NumberFormatter()
        print(formatter.plusSign)
    }
    
    
    
    /*
     *  default: E
     *  desc: 指数符号
     */
    
    // open var exponentSymbol: String!
    @objc func exponentSymbol() {
        let formatter = NumberFormatter()
        print(formatter.exponentSymbol)
    }
    
    
    
    /*
     *  default: 3
     *  desc: 数字分割的尺寸
     */
    
    // open var groupingSize: Int
    @objc func groupingSize() {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.groupingSize)
        let str = formatter.string(from: 123456) // $123,456.00
        print(str as Any)
        formatter.groupingSize = 1
        let str1 = formatter.string(from: 123456) // $1,2,3,4,5,6.00
        print(str1 as Any)
    }
    
    
    /*
     *  default: 0
     *  desc: 除了groupingSize决定的尺寸外,其他数字位分割的尺寸
     */
    
    // open var secondaryGroupingSize: Int
    @objc func secondaryGroupingSize() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.secondaryGroupingSize)
        let str = formatter.string(from: 123456) // $123,456.00
        print(str as Any)
        formatter.secondaryGroupingSize = 1
        let str1 = formatter.string(from: 123456) // $1,2,3,456.00
        print(str1 as Any)
    }
    
    
    /*
     *  default: nil
     *  desc: 乘数
     */
    
    // @NSCopying open var multiplier: NSNumber?
    @objc func multiplier() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.multiplier as Any)
        let str = formatter.string(from: 123456) // $123,456.00
        print(str as Any)
        formatter.multiplier = 10
        let str1 = formatter.string(from: 123456) // $1,234,560.00
        print(str1 as Any)
    }
    
    
    /*
     *  default: 0
     *  desc: 格式化宽度（字符串所有字符个数）
     */
    
    // open var formatWidth: Int
    @objc func formatWidth() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.formatWidth)
        let str = formatter.string(from: 123456) // "$123,456.00"
        print(str as Any)
        formatter.formatWidth = 15
        let str1 = formatter.string(from: 123456) // "    $123,456.00"
        print(str1 as Any)
    }
    
    
    /*
     *  default: ''
     *  desc: 填充符号
     */
    
    // open var paddingCharacter: String!
    
    @objc func paddingCharacter() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.paddingCharacter)
        let str = formatter.string(from: 123456) // "$123,456.00"
        print(str as Any)
        formatter.formatWidth = 15
        formatter.paddingCharacter = "*"
        let str1 = formatter.string(from: 123456) // "****$123,456.00"
        print(str1 as Any)
    }
    
    
    /*
     *  default: beforePrefix
     *  desc: 填充方向
     */
    
    // open var paddingPosition: NumberFormatter.PadPosition
    @objc func paddingPosition() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.paddingPosition == .beforePrefix)
        formatter.formatWidth = 15
        formatter.paddingCharacter = "*"
        let str = formatter.string(from: 123456) // "****$123,456.00"
        print(str as Any)
        formatter.paddingPosition = NumberFormatter.PadPosition.afterPrefix
        let str1 = formatter.string(from: 123456) // "$****123,456.00"
        print(str1 as Any)
    }
    
    
    /*
     *  default: halfEven
     *  desc: 舍入方式
     */
    
    // open var roundingMode: NumberFormatter.RoundingMode
    @objc func roundingMode() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.roundingMode == .halfEven)
        let str = formatter.string(from: 123456.1235) // "123,456.124"
        print(str as Any)
        formatter.roundingMode = .halfDown
        let str1 = formatter.string(from: 123456.1235) // "123,456.123"
        print(str1 as Any)
    }
    
    
    
    /*
     *  default: 0
     *  desc: 保留到哪位小数
     */
    
    // @NSCopying open var roundingIncrement: NSNumber!
    @objc func roundingIncrement() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.roundingIncrement)
        let str = formatter.string(from: 123456.1235) // "123,456.124"
        print(str as Any)
        formatter.roundingIncrement = 0.1
        let str1 = formatter.string(from: 123456.1235) // "123,456.1"
        print(str1 as Any)
    }
    
    
    /*
     *  default: 1
     *  desc: 整数最少位数
     */
    // open var minimumIntegerDigits: Int
    @objc func minimumIntegerDigits() {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.minimumIntegerDigits)
        let str = formatter.string(from: 123456.1235) // "123,456.124"
        print(str as Any)
        formatter.minimumIntegerDigits = 10
        let str1 = formatter.string(from: 123456.1235) // "0,000,123,456.124"
        print(str1 as Any)
    }
    
    
    /*
     *  default: 2000000000
     *  desc: 整数最多位数
     */
    
    // open var maximumIntegerDigits: Int
    @objc func maximumIntegerDigits() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.maximumIntegerDigits)
        let str = formatter.string(from: 123456.1235) // "123,456.124"
        print(str as Any)
        formatter.maximumIntegerDigits = 1
        let str1 = formatter.string(from: 123456.1235) // "6.124"
        print(str1 as Any)
    }
    
    
    /*
     *  default: 0
     *  desc: 小数最少位数
     */
    
    // open var minimumFractionDigits: Int
    @objc func minimumFractionDigits() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.minimumFractionDigits)
        let str = formatter.string(from: 123456.1235) // "123,456.124"
        print(str as Any)
        formatter.minimumFractionDigits = 10
        let str1 = formatter.string(from: 123456.1235) // "123,456.1235000000"
        print(str1 as Any)
    }
    
    
    
    /*
     *  default: 3 会根据numberStyle的值变化
     *  desc: 小数最多位数
     */
    
    // open var maximumFractionDigits: Int
    @objc func maximumFractionDigits() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.maximumFractionDigits)
        let str = formatter.string(from: 123456.1235) // "123,456.124"
        print(str as Any)
        formatter.maximumFractionDigits = 1
        let str1 = formatter.string(from: 123456.1235) // "123,456.1"
        print(str1 as Any)
    }
    
    
    
    /*
     *  default: nil
     *  desc: ??? 接收器允许输入的最小数字。
     */
    
    // @NSCopying open var minimum: NSNumber?
    
    @objc func minimum() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.minimum as Any)
    }
    
    
    /*
     *  default: nil
     *  desc: ??? 接收器允许输入的最大数字。
     */
    
    // @NSCopying open var maximum: NSNumber?
    @objc func maximum() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        print(formatter.maximum as Any)
    }
    
    
    /*
     *  default: ','
     *  desc: 货币格式分隔符
     */
    
    // open var currencyGroupingSeparator: String!
    @objc func currencyGroupingSeparator() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.currencyGroupingSeparator as Any)
        let str = formatter.string(from: 123456.1235) // "$123,456.12"
        print(str as Any)
        formatter.currencyGroupingSeparator = "*"
        let str1 = formatter.string(from: 123456.1235) // "$123*456.12"
        print(str1 as Any)
    }
    
    
    /*
     *  default: false
     *  desc: ??? 确定接收器是否将使用启发式来猜测字符串意图的数字。
     */
    
    // open var isLenient: Bool
    @objc func isLenient() {
        let formatter = NumberFormatter()
        print(formatter.isLenient)
    }
    
    
    /*
     *  default: false
     *  desc: 是否使用有效数字
     */
    
    // open var usesSignificantDigits: Bool
    @objc func usesSignificantDigits() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.usesSignificantDigits)
        let str = formatter.string(from: 123456.1235) // "$123,456.12"
        print(str as Any)
        formatter.usesSignificantDigits = true
        let str1 = formatter.string(from: 123456.1235) // "$123,456"
        print(str1 as Any)
    }
    
    
    /*
     *  default: 1
     *  desc: 最小有效数字位数
     */
    
    // open var minimumSignificantDigits: Int
    @objc func minimumSignificantDigits() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.minimumSignificantDigits)
        let str = formatter.string(from: 123456.1235) // "$123,456.12"
        print(str as Any)
        formatter.minimumSignificantDigits = 10
        let str1 = formatter.string(from: 123456.1235) // "$123,456.1235"
        print(str1 as Any)
    }
    
    
    /*
     *  default: 6
     *  desc: 最大有效数字位数
     */
    
    // open var maximumSignificantDigits: Int
    @objc func maximumSignificantDigits() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        print(formatter.maximumSignificantDigits)
        let str = formatter.string(from: 123456.1235) // "$123,456.12"
        print(str as Any)
        formatter.maximumSignificantDigits = 2
        let str1 = formatter.string(from: 123456.1235) // "$120,000"
        print(str1 as Any)
        formatter.maximumSignificantDigits = 3
        let str2 = formatter.string(from: 123456.1235) // "$123,000"
        print(str2 as Any)
    }
    
    
    /*
     *  default: false
     *  desc: ??? 确定是否为接收器启用部分字符串验证。
     */
    
    // open var isPartialStringValidationEnabled: Bool
    @objc func isPartialStringValidationEnabled() {
        let formatter = NumberFormatter()
        print(formatter.isPartialStringValidationEnabled)
    }
}

