//
//  InputBarController.swift
//  ExUIDatePicker
//
//  Created by 黄伯驹 on 28/01/2018.
//  Copyright © 2018 hsin. All rights reserved.
//

import UIKit

let width = UIScreen.main.bounds.width

class InputBar: UIView {
    let textView = UITextField(frame: CGRect(x: 50, y: 7, width: width - 100, height: 30))

    override init(frame: CGRect) {
        super.init(frame: frame)

        let blurEffect = UIBlurEffect(style: .extraLight)
        let visualView = UIVisualEffectView(effect: blurEffect)
        visualView.frame = frame
        addSubview(visualView)

        backgroundColor = .red
        textView.borderStyle = .roundedRect
        addSubview(textView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class InputBarController: BaseController {
    let accessoryView = InputBar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
    override var inputAccessoryView: UIView? {
        return accessoryView
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func initSubviews() {
    }
}
