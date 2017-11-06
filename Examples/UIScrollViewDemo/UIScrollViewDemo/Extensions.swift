//
//  Extensions.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

public class NotificationNames {
    fileprivate init() {}
}

/// Base class for static user defaults keys. Specialize with value type
/// and pass key name to the initializer to create a key.

public class NotificationName: NotificationNames {
    // TODO: Can we use protocols to ensure ValueType is a compatible type?
    public let _key: String
    
    public init(_ key: String) {
        self._key = key
        super.init()
    }
}

extension NotificationCenter {
    static func postNotification(name: NotificationName, object: Any? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name._key), object: object)
    }
}


extension UIViewController {
    func addObserver(with selector: Selector, name: NotificationName, object: Any? = nil) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name._key), object: object)
    }
    
    func postNotification(name: NotificationName, object: Any? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name._key), object: object)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }

    @discardableResult
    func showAlert(actionTitle: String = "确定", title: String? = nil, message: String?, style: UIAlertControllerStyle = .alert, handle: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        present(alert, animated: true, completion: nil)
        return alert.action(actionTitle, handle)
    }
}

extension UIAlertController {
    @discardableResult
    func action(_ title: String, style: UIAlertActionStyle = .`default`, _ handle: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let action = UIAlertAction(title: title, style: style, handler: handle)
        addAction(action)
        return self
    }
}
