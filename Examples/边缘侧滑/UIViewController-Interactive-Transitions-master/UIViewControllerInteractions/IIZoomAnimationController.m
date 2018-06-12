//
//  IIZoomAnimationController.m
//  InteractionDemo
//
//  Created by Daniel Broad on 04/07/2013.
//  Copyright (c) 2013 Dorada Software Ltd. All rights reserved.
//

#import "IIZoomAnimationController.h"

@interface IIZoomAnimationController ()
@property (weak) UIViewController* to;
@end

@implementation IIZoomAnimationController

-(id) initToVC: (UIViewController*) to {
    self = [super init];
    if (self) {
        self.to = to;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    

    
    if (fromViewController == self.to) { // dismiss
        [containerView addSubview:toViewController.view];
        [containerView addSubview:fromViewController.view];
        [fromViewController.view setFrame:containerView.bounds];
        [toViewController.view setFrame:[transitionContext finalFrameForViewController:toViewController]];
        
        [UIView animateWithDuration:duration animations:^{
            [fromViewController.view setFrame:CGRectInset(containerView.bounds, 160, 240)];
            toViewController.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {  // present
        [containerView addSubview:fromViewController.view];
        [containerView addSubview:toViewController.view];
        [fromViewController.view setFrame:[transitionContext finalFrameForViewController:fromViewController]];
        [toViewController.view setFrame:CGRectInset(containerView.bounds, 160, 240)];
        
        [UIView animateWithDuration:duration animations:^{
            [toViewController.view setFrame:containerView.bounds];
            fromViewController.view.alpha = 0.5f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            
        }];
    }

    
}
@end
