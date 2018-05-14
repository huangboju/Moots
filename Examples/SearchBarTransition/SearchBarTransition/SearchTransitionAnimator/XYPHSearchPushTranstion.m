//
//  SearchTranstion.m
//  SearchBarTransition
//
//  Created by 黄伯驹 on 02/02/2018.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

#import "XYPHSearchPushTranstion.h"

@implementation XYPHSearchPushTranstion

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    CGRect rect = fromVC.view.frame;

    toVC.view.frame = CGRectMake(rect.origin.x, 150 - 74, rect.size.width, rect.size.height);

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.05 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.frame = CGRectMake(rect.origin.x, -150 + 74, rect.size.width, rect.size.height);
        toVC.view.frame = CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);
    } completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
