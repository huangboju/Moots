//
//  UIView+LazyScrollView.swift
//  LazyScrollView
//
//  Created by 伯驹 黄 on 2016/12/9.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

extension UIView {
    struct Keys {
        static var reuseIdentifierKey: String? = "reuseIdentifierKey"
        static var lazyIDKey: String? = "lazyIDkey"
    }

    var lazyID: String? {
        set {
            objc_setAssociatedObject(self, &Keys.lazyIDKey, newValue, .OBJC_ASSOCIATION_COPY)
        }

        get {
            return objc_getAssociatedObject(self, &Keys.lazyIDKey) as? String
        }
    }

    var reuseIdentifier: String? {
        set {
            objc_setAssociatedObject(self, &Keys.reuseIdentifierKey, newValue, .OBJC_ASSOCIATION_COPY)
        }

        get {
            return objc_getAssociatedObject(self, &Keys.reuseIdentifierKey) as? String
        }
    }

    class func view(with lazyID: String, reuseIdentifier: String) -> UIView {
        
        let view = UIView()
        view.lazyID = lazyID
        view.reuseIdentifier = reuseIdentifier

        return view
    }
}
