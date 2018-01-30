//
//  InputBar1Controller.swift
//  ExUIDatePicker
//
//  Created by 黄伯驹 on 29/01/2018.
//  Copyright © 2018 hsin. All rights reserved.
//

import UIKit

class InputBar1: UIView {
    
    let bar = InputBar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
    
    override var inputAccessoryView: UIView? {
        return bar
    }
     
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        bar.textView.becomeFirstResponder()
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
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputBar1.becomeFirstResponder()
    }
}
