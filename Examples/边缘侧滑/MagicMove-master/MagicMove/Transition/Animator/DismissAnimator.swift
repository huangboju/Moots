//
//  DismissAnimator.swift
//  MagicMove
//
//  Created by xiAo_Ju on 2018/6/13.
//  Copyright © 2018 Bourne. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject {
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

extension DismissAnimator: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransition()
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animator is DismissTransition {
            return percentDrivenTransition
        } else {
            return nil
        }
    }
}
