//
//  MagicMovePushTransion.swift
//  MagicMove
//
//  Created by xiAo_Ju on 2018/6/12.
//  Copyright © 2018 Bourne. All rights reserved.
//

import UIKit

class MagicMovePushTransion: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //1.获取动画的源控制器和目标控制器
        guard let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        let screenBounds = UIScreen.main.bounds
        
        let x      = screenBounds.width - toView.bounds.minX
        fromView.alpha = 0.2

        toView.frame.origin.x = x

        let containerView = transitionContext.containerView
        
        containerView.insertSubview(toView, belowSubview: fromView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            fromView.frame.origin.x = x
            fromView.alpha = 1

            toView.frame.origin.x = 0
        }, completion: { _ in
            fromView.frame.origin.x = 0
            fromView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
