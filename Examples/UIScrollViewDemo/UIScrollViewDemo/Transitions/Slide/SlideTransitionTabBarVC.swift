//
//  SlideTransitionTabBarVC.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/14.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class SlideTransitionTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vcs = [
            SlideTransitionFirstVC(),
            SlideTransitionSecondVC(),
            SlideTransitionThirdVC()
        ]
        for vc in vcs {
            vc.tabBarItem.title = "\(vc.classForCoder)"
            addChild(vc)
        }

        let slideTransitionDelegate = SlideTransitionDelegate()
        slideTransitionDelegate.tabBarController = self
        delegate = slideTransitionDelegate
    }
}
