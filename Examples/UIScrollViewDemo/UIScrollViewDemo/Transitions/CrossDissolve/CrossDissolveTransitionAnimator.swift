//
//  CrossDissolveTransitionAnimator.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/12.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class CrossDissolveTransitionAnimator: NSObject {

}

extension CrossDissolveTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        // In iOS 8, the viewForKey: method was introduced to get views that the
        // animator manipulates.  This method should be preferred over accessing
        // the view of the fromViewController/toViewController directly.
        // It may return nil whenever the animator should not touch the view
        // (based on the presentation style of the incoming view controller).
        // It may also return a different view for the animator to animate.
        //
        // Imagine that you are implementing a presentation similar to form sheet.
        // In this case you would want to add some shadow or decoration around the
        // presented view controller's view. The animator will animate the
        // decoration view instead and the presented view controller's view will
        // be a child of the decoration view.
        
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else { return }
        
        
        fromView.frame = transitionContext.initialFrame(for: fromVC)
        toView.frame = transitionContext.finalFrame(for: toVC)
        
        fromView.alpha = 1.0
        toView.alpha = 0.0
        
        // We are responsible for adding the incoming view to the containerView
        // for the presentation/dismissal.
        containerView.addSubview(toView)
        
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromView.alpha = 0.0
            toView.alpha = 1.0
        }, completion: { finished in
            // When we complete, tell the transition context
            // passing along the BOOL that indicates whether the transition
            // finished or not.
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        })
    }
}
