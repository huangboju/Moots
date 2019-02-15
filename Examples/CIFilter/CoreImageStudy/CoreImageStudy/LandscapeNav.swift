//
//  LandscapeNav.swift
//  CoreImageStudy
//
//  Created by xiAo_Ju on 2019/2/15.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class LandscapeNav: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        transitioningDelegate = self
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
}

extension LandscapeNav: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LandscapeTransitionAnimator(targetEdge: .top)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LandscapeTransitionAnimator(targetEdge: .left)
    }
}
