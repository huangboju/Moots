//
//  PresentationManager.swift
//  PresentDebug
//
//  Created by xiAo_Ju on 2018/10/18.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

class PresentationManager: NSObject {

}

extension PresentationManager: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimator(isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimator(isPresentation: false)
    }
}
