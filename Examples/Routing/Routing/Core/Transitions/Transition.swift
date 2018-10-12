//
//  Transition.swift
//  Routing
//
//  Created by 黄伯驹 on 2018/7/28.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

protocol Transition: class {
    var viewController: UIViewController? { get set }
    
    func open(_ viewController: UIViewController)

    func close(_ viewController: UIViewController)
}






