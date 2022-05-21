//
//  Segue.swift
//  Lumia
//
//  Created by xiAo_Ju on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    
    public func show<C: UIViewController>(_ segue: Segue, animated: Bool = true, handle: ((C) -> Void)? = nil) {
        let vc: UIViewController
        switch segue {
        case let .controller(c):
            vc = c
        case let .segue(c):
            vc = c.init()
        case let .modal(c):
            vc = c.init()
            if let c = vc as? C {
                handle?(c)
            }
            vc.modalPresentationStyle = .fullScreen
            showDetailViewController(vc, sender: nil)
            return
        case let .web(url):
            showDetailViewController(SFSafariViewController(url: URL(string: url)!), sender: nil)
            return
        case let .scheme(s):
            guard let url = URL(string: s.scheme) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            return
        default:
            return
        }
        if let c = vc as? C {
            handle?(c)
        }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: animated)
    }
}

public enum Segue {
    case none
    // 用SegueRow，把创建对象延迟到跳转时
    case segue(UIViewController.Type)
    case modal(UIViewController.Type)
    case controller(UIViewController)
    case web(String)
    case scheme(Scheme)
}

extension Segue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "none"
        case let .segue(dest):
            return "\(dest)"
        case let .controller(vc):
            return vc.description
        case let .web(str):
            return "\(str)"
        case let .scheme(s):
            return "\(s.scheme)"
        case let .modal(dest):
            return "\(dest)"
        }
    }
}

// https://github.com/cyanzhong/app-tutorials/blob/master/schemes.md
// http://www.jianshu.com/p/bb3f42fdbc31
public enum Scheme {
    case plain(String)
    case tel(String)
    case wifi
    case appStore
    case mail(String)
    case notification
    
    var scheme: String {
        let scheme: String
        switch self {
        case let .plain(s):
            scheme = s
        case let .tel(s):
            scheme = "tel://" + s
        case .wifi:
            scheme = "App-Prefs:root=WIFI"
        case .appStore:
            scheme = "itms-apps://itunes.apple.com/cn/app/id\(1111)?mt=8"
        case let .mail(s):
            scheme = "mailto://\(s)"
        case .notification:
            scheme = "App-Prefs:root=NOTIFICATIONS_ID"
        }
        return scheme
    }
}
