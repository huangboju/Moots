//
//  UIViewController+SafeAreaInsets.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 10/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var sa_safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11, *) {
            return view.safeAreaInsets
        }
        return UIEdgeInsets(top: topLayoutGuide.length, left: 0.0, bottom: bottomLayoutGuide.length, right: 0.0)
    }

    var sa_safeAreaFrame: CGRect {
        if #available(iOS 11, *) {
            return view.safeAreaLayoutGuide.layoutFrame
        }
        return view.bounds.inset(by: sa_safeAreaInsets)
    }
}
