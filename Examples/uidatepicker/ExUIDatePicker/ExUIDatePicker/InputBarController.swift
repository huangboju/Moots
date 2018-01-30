//
//  InputBarController.swift
//  ExUIDatePicker
//
//  Created by 黄伯驹 on 28/01/2018.
//  Copyright © 2018 hsin. All rights reserved.
//

import UIKit

let width = UIScreen.main.bounds.width

// https://stackoverflow.com/questions/25816994/changing-the-frame-of-an-inputaccessoryview-in-ios-8

class InputBar: UIView, UITextViewDelegate {
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var visualView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let visualView = UIVisualEffectView(effect: blurEffect)
        visualView.translatesAutoresizingMaskIntoConstraints = false
        return visualView
    }()
    
    private lazy var emojiButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon_emotion"), for: .normal)
        button.addTarget(self, action: #selector(showEmojiKeyboard), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        autoresizingMask = .flexibleHeight

        backgroundColor = .red
        
        addSubview(visualView)
        visualView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        visualView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        visualView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        visualView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        

        addSubview(textView)
        textView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        textView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        textView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(emojiButton)
        emojiButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        emojiButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        invalidateIntrinsicContentSize()
    }
    
    @objc
    func showEmojiKeyboard(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 200))
            keyboardView.backgroundColor = .red
            textView.resignFirstResponder()
            textView.inputView = keyboardView
        } else {
            textView.inputView = nil
        }
        textView.reloadInputViews()
    }
    
    override var intrinsicContentSize: CGSize {
        // Calculate intrinsicContentSize that will fit all the text
        let textSize = textView.contentSize
        return CGSize(width: bounds.width, height: textSize.height)
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
