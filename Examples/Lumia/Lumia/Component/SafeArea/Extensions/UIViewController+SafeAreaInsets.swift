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
        view.safeAreaInsets
    }

    var sa_safeAreaFrame: CGRect {
        view.safeAreaLayoutGuide.layoutFrame
    }
}
