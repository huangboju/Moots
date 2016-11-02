//
//  HeaderView.swift
//  NSNumberFormatter
//
//  Created by 伯驹 黄 on 2016/11/2.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

protocol HeaderViewPresenter: class {
    var textField: UITextField? { set get }
    var displayLabel: UILabel? { set get }
}

extension HeaderViewPresenter where Self: UIViewController {
    func setupHeaderView() {
        displayLabel = UILabel(frame: CGRect(x: 15, y: 69, width: view.frame.width - 30, height: 44))
        displayLabel?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.addSubview(displayLabel!)
        
        textField = UITextField(frame: CGRect(x: 15, y: 121, width: view.frame.width - 30, height: 34))
        textField?.borderStyle = .line
        textField?.layer.cornerRadius = 5
        textField?.keyboardType = .decimalPad
        textField?.clipsToBounds = true
        textField?.placeholder = "请输入"
        view.addSubview(textField!)
    }
}
