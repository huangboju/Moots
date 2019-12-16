//
//  ViewController.swift
//  TextField
//
//  Created by 伯驹 黄 on 2016/10/12.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    fileprivate lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 100, y: 100, width: 100, height: 44))
        textField.setValue(UIColor.yellow, forKeyPath: "_placeholderLabel.textColor")
        textField.text = "有光标无键盘"
        textField.placeholder = "13423143214"
        return textField
    }()
    fileprivate lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        return tableView
    }()
    fileprivate lazy var cursorView: UIView = {
        let cursorView = UIView(frame: CGRect(x: 15, y: 10, width: 2, height: 24))
        cursorView.backgroundColor = UIColor.blue
        cursorView.layer.add(self.opacityForever_Animation(), forKey: nil)
        return cursorView
    }()
    
    var animation: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.4
        animation.autoreverses = true
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        animation.fromValue = NSNumber(value: 1.0)
        animation.toValue = NSNumber(value: 0.0)
        return animation
    }
    
    func opacityForever_Animation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")//必须写opacity才行。
        animation.fromValue = NSNumber(value: 1.0)
        animation.toValue = NSNumber(value: 0.0)
//        animation.autoreverses = true
        animation.duration = 0.8
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.removed
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)///没有的话是均匀的动画。
        return animation
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(calueChange), name: UITextField.textDidBeginEditingNotification, object: nil)
        view.addSubview(tableView)
    }
    
    @objc func buttonAction() {
        textField.inputView = nil
        textField.reloadInputViews() // 重载输入视图
    }
    
    @objc func calueChange() {
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = indexPath.row.description
        if indexPath == IndexPath(row: 0, section: 0) {
            textField.inputView = UIView()
            textField.becomeFirstResponder()
            textField.removeFromSuperview()
            button.removeFromSuperview()
            cell.textLabel?.sizeToFit()
            textField.frame = CGRect(x: 15 + cell.textLabel!.frame.width, y: 0, width: view.frame.width - 30, height: 44)
            textField.backgroundColor = UIColor.red
            cell.contentView.addSubview(textField)
            button.frame = textField.frame
            cell.contentView.addSubview(button)
        } else if indexPath == IndexPath(row: 1, section: 0) {
            cursorView.removeFromSuperview()
            cell.textLabel?.text = "假光标"
            cell.contentView.addSubview(cursorView)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

