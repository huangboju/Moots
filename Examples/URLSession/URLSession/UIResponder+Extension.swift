//
//  UIResponder+Extension.swift
//  Router
//
//  Created by 伯驹 黄 on 2016/12/7.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

extension UIResponder {

    struct Keys {
        static let longPress = "longPress"
    }

    struct EventName {
        static let transferNameEvent = "transferNameEvent"
    }

    func router(with eventName: String, userInfo: [String: Any]) {
        if let next = next {
            next.router(with: eventName, userInfo: userInfo)
        }
    }
}
