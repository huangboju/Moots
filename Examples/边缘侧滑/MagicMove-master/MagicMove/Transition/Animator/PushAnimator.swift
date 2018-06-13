//
//  PushAnimator.swift
//  MagicMove
//
//  Created by 黄伯驹 on 2018/6/13.
//  Copyright © 2018 Bourne. All rights reserved.
//

import UIKit

class PushAnimator: NSObject {
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

extension PushAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MagicMovePushTransion()
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animator is MagicMovePushTransion {
            return percentDrivenTransition
        } else {
            return nil
        }
    }
}
