//
//  Animation.swift
//  ADController
//
//  Created by 伯驹 黄 on 2016/10/19.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
}
