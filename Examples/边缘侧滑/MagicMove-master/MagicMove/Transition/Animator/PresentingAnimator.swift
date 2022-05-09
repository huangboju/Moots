//
//  PushAnimator.swift
//  MagicMove
//
//  Created by 黄伯驹 on 2018/6/13.
//  Copyright © 2018 Bourne. All rights reserved.
//

import UIKit

class PresentingAnimator: NSObject {
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?

    func begin() {
        percentDrivenTransition = UIPercentDrivenInteractiveTransition()
    }

    func update(_ percentComplete: CGFloat) {
        percentDrivenTransition?.update(percentComplete)
    }
    
    func finish() {
        percentDrivenTransition?.finish()
    }
    
    func cancel() {
        percentDrivenTransition?.cancel()
    }
    
    func invalidate() {
        percentDrivenTransition = nil
    }
}

extension PresentingAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingTransion()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransition(duration: 0.25)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animator is PresentingTransion {
            return percentDrivenTransition
        } else {
            return nil
        }
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return MyPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
