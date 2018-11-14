//
//  SlideTransitionAnimator.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/14.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class SlideTransitionAnimator: NSObject {
    var targetEdge: UIRectEdge = []

    init(targetEdge: UIRectEdge) {
        super.init()
        self.targetEdge = targetEdge
    }
}

extension SlideTransitionAnimator: UIViewControllerAnimatedTransitioning {
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
        
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        
        let fromFrame = transitionContext.initialFrame(for: fromVC)
        let toFrame = transitionContext.finalFrame(for: toVC)
        
        // Based on the configured targetEdge, derive a normalized vector that will
        // be used to offset the frame of the view controllers.
        let offset: CGVector
        if targetEdge == .left {
            offset = CGVector(dx: -1, dy: 0)
        } else if targetEdge == .right {
            offset = CGVector(dx: 1, dy: 0)
        } else {
            fatalError("targetEdge must be one of UIRectEdgeLeft, or UIRectEdgeRight.")
        }
        
        // The toView starts off-screen and slides in as the fromView slides out.
        fromView?.frame = fromFrame
        toView?.frame = toFrame.offsetBy(dx: toFrame.size.width * offset.dx * -1,
                                          dy: toFrame.size.height * offset.dy * -1)
        
        // We are responsible for adding the incoming view to the containerView.
        if let toView = toView {
            containerView.addSubview(toView)
        }
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: transitionDuration, animations: {
            fromView?.frame = fromFrame.offsetBy(dx: fromFrame.size.width * offset.dx,
                                                dy: fromFrame.size.height * offset.dy)
            toView?.frame = toFrame
        }, completion: { _ in
            let wasCancelled = transitionContext.transitionWasCancelled
            // When we complete, tell the transition context
            // passing along the BOOL that indicates whether the transition
            // finished or not.
            transitionContext.completeTransition(!wasCancelled)
        })
    }
}
