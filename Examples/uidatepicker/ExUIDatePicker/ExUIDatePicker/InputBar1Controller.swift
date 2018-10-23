//
//  InputBar1Controller.swift
//  ExUIDatePicker
//
//  Created by 黄伯驹 on 29/01/2018.
//  Copyright © 2018 hsin. All rights reserved.
//

import UIKit

class InputBar1: UIView {
    
    let bar = InputBar(frame: CGRect(x: 0, y: 0, width: width, height: 47))
    
    override var inputAccessoryView: UIView? {
        return bar
    }
     
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        bar.textView.becomeFirstResponder()
        return result
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        bar.textView.resignFirstResponder()
        return result
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}


class InputBar1Controller: UIViewController {

    
    let inputBar1 = InputBar1()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(inputBar1)
        let item1 = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction))
        let item2 = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeAction))
        navigationItem.rightBarButtonItems = [item1, item2]
    }

    @objc func editAction() {
        inputBar1.becomeFirstResponder()
    }
    
    @objc func closeAction() {
        inputBar1.resignFirstResponder()
    }
}
