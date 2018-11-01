//
//  ImageDetailPresentAnimator.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 5/10/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

class ImageDetailPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var sourceFrame = CGRect.zero
        
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ImageDetailTransitionsOptions.PresentAnimationDuration
    }
 
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
              let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        let xScaleFactor = sourceFrame.width / finalFrame.width
        let yScaleFactor = sourceFrame.height / finalFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        toView.alpha = 0.0
        toView.frame = finalFrame
        toView.transform = scaleTransform
        toView.center = CGPoint(
            x: sourceFrame.midX,
            y: sourceFrame.midY
        )
        toView.clipsToBounds = true
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.0,
                       usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0,
                       options: [], animations: {
            toView.alpha = 1.0
            toView.transform = CGAffineTransform.identity
            toView.center = CGPoint(
                x: finalFrame.midX,
                y: finalFrame.midY
            )
        }, completion: {_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
