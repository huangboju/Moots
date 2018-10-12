//
//  Animator.swift
//  Routing
//
//  Created by 黄伯驹 on 2018/7/28.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

protocol Animator: UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool { set get }
}


