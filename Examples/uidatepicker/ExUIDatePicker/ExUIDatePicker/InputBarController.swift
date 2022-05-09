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
        textView.layer.borderWidth = 0.5
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
        let button = InputBar.generateButton(with: "icon_emotion")
        return button
    }()
    
    private lazy var secondButton: UIButton = {
        let button = InputBar.generateButton(with: "icon_emotion")
        return button
    }()
    
    private lazy var thirdButton: UIButton = {
        let button = InputBar.generateButton(with: "icon_emotion")
        return button
    }()
    
    static func generateButton(with imageName: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(self, action: #selector(showEmojiKeyboard), for: .touchUpInside)
        return button
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        autoresizingMask = .flexibleHeight

        backgroundColor = .red
        
        addSubview(visualView)
        visualView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        visualView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        visualView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        visualView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let margin: CGFloat = 8

        addSubview(emojiButton)
        emojiButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        emojiButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
        addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: emojiButton.trailingAnchor, constant: margin).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        textView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        addSubview(secondButton)
        secondButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: margin).isActive = true
        secondButton.widthAnchor.constraint(equalTo: emojiButton.widthAnchor).isActive = true
        secondButton.heightAnchor.constraint(equalTo: emojiButton.heightAnchor).isActive = true
        secondButton.centerYAnchor.constraint(equalTo: emojiButton.centerYAnchor).isActive = true

        addSubview(thirdButton)
        thirdButton.leadingAnchor.constraint(equalTo: secondButton.trailingAnchor, constant: margin).isActive = true
        thirdButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
        thirdButton.widthAnchor.constraint(equalTo: emojiButton.widthAnchor).isActive = true
        thirdButton.heightAnchor.constraint(equalTo: emojiButton.heightAnchor).isActive = true
        thirdButton.centerYAnchor.constraint(equalTo: emojiButton.centerYAnchor).isActive = true
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
