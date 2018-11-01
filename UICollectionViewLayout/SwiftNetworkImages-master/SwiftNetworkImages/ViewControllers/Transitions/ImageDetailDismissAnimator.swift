//
//  ImageDetailDismissAnimator.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 4/10/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

class ImageDetailDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ImageDetailTransitionsOptions.DismissAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.0,
                       options: [],
                       animations: {
            fromView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            fromView.alpha = 0.0
        }, completion: {_ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
