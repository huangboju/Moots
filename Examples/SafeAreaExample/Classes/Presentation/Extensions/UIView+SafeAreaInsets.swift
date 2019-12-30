//
//  UIView+SafeAreaInsets.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 10/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

extension UIView {
    
    var sa_safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11, *) {
            return safeAreaInsets
        }
        return UIEdgeInsets.zero
    }
    
    var sa_safeAreaFrame: CGRect {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide.layoutFrame
        }
        return bounds
    }
}
