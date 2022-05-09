//
//  UICopyLabel.swift
//  URLSession
//
//  Created by 黄伯驹 on 2017/9/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

// http://www.hangge.com/blog/cache/detail_1085.html
// http://www.jianshu.com/p/10a6900cc904

class UICopyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
    }
    
    @objc func showMenu(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            becomeFirstResponder()
            let menu = UIMenuController.shared
            if !menu.isMenuVisible {
                menu.setTargetRect(bounds, in: self)
                menu.setMenuVisible(true, animated: true)
            }
        default:
            break
        }
    }
    
    //复制
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = text
        let menu = UIMenuController.shared
        menu.setMenuVisible(false, animated: true)
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return true
        }
        return false
    }
}
