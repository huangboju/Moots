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
        UIPresentationController
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //1.获取动画的源控制器和目标控制器
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }

        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor(white: 0, alpha: 0)
        containerView.addSubview(toView)

        let containerViewSize = containerView.frame.size

        let x = containerViewSize.width - toView.bounds.minX
        toView.frame.origin.x = x
        let endX: CGFloat = 100
        toView.frame.size = CGSize(width: containerViewSize.width - endX, height: containerViewSize.height)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            toView.frame.origin.x = endX
            containerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
