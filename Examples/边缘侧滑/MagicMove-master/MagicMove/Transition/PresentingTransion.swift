//
//  MagicMovePushTransion.swift
//  MagicMove
//
//  Created by xiAo_Ju on 2018/6/12.
//  Copyright © 2018 Bourne. All rights reserved.
//

import UIKit

class PresentingTransion: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //1.获取动画的源控制器和目标控制器
        guard let toView = transitionContext.view(forKey: .to),
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let presentedFrame = transitionContext.finalFrame(for: toVC)

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)

        let containerViewSize = containerView.frame.size

        let x = containerViewSize.width - toView.bounds.minX
        toView.frame.origin.x = x

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            toView.frame = presentedFrame
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
