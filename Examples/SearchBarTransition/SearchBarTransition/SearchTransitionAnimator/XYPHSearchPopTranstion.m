//
//  SearchPopTranstion.m
//  SearchBarTransition
//
//  Created by 黄伯驹 on 02/02/2018.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

#import "XYPHSearchPopTranstion.h"

@implementation XYPHSearchPopTranstion

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    CGRect rect = toVC.view.frame;
    toVC.view.frame = CGRectMake(rect.origin.x, -150 + 74, rect.size.width, rect.size.height);
    [containerView addSubview:toVC.view];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.05 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        toVC.view.frame = CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
