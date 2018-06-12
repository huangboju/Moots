//
//  IISwipeAnimatonController.m
//  InteractionDemo
//
//  Created by Daniel Broad on 11/07/2013.
//  Copyright (c) 2013 Dorada Software Ltd. All rights reserved.
//

#import "IISwipeAnimationController.h"

@interface IISwipeAnimationController ()
@property (weak) UIViewController* to;
@end

@implementation IISwipeAnimationController

-(id) initToVC: (UIViewController*) to {
    self = [super init];
    if (self) {
        self.to = to;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4f;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (toViewController != self.to) { // dismiss
        NSLog(@"Animation Dismiss");
        [containerView addSubview:toViewController.view];
        [containerView addSubview:fromViewController.view];
        [fromViewController.view setFrame:containerView.bounds];
        [toViewController.view setFrame:[transitionContext finalFrameForViewController:toViewController]];
        CGRect bounds = containerView.bounds;
        [UIView animateWithDuration:duration animations:^{
            if (UIInterfaceOrientationIsPortrait(self.orientation)) {
                [fromViewController.view setFrame:CGRectOffset(bounds, 0, bounds.size.height)];
            } else if (self.orientation == UIInterfaceOrientationLandscapeLeft) {
                [fromViewController.view setFrame:CGRectOffset(bounds, bounds.size.width, 0)];
            } else if  (self.orientation == UIInterfaceOrientationLandscapeRight) {
                [fromViewController.view setFrame:CGRectOffset(bounds, -bounds.size.width, 0)];
            }
            toViewController.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!self.wasCancelled];
            NSLog(@"Animation Dismiss Finished");
        }];
    } else {  // present
        NSLog(@"Animation Present");
        [containerView addSubview:fromViewController.view];
        [containerView addSubview:toViewController.view];
        [fromViewController.view setFrame:[transitionContext finalFrameForViewController:fromViewController]];
        CGRect bounds = containerView.bounds;
        if (UIInterfaceOrientationIsPortrait(self.orientation)) {
            [toViewController.view setFrame:CGRectOffset(bounds, 0, bounds.size.height-self.yOffset)];
        } else if (self.orientation == UIInterfaceOrientationLandscapeLeft) {
             [toViewController.view setFrame:CGRectOffset(bounds, bounds.size.width-self.yOffset, 0)];
        } else if  (self.orientation == UIInterfaceOrientationLandscapeRight) {
            [toViewController.view setFrame:CGRectOffset(bounds, -bounds.size.width+self.yOffset, 0)];
        }
        
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [toViewController.view setFrame:containerView.bounds];
            fromViewController.view.alpha = 0.1f;
        } completion:^(BOOL finished) {
            NSLog(@"Animation Present Finished %d %d",finished,!self.wasCancelled);
//            if (self.wasCancelled) {
//                [toViewController.view removeFromSuperview];
//                fromViewController.view.alpha = 1.0f;
//                if (UIInterfaceOrientationIsPortrait(self.orientation)) {
//                    [toViewController.view setFrame:CGRectOffset(bounds, 0, bounds.size.height-self.yOffset)];
//                } else if (self.orientation == UIInterfaceOrientationLandscapeLeft) {
//                    [toViewController.view setFrame:CGRectOffset(bounds, bounds.size.width-self.yOffset, 0)];
//                } else if  (self.orientation == UIInterfaceOrientationLandscapeRight) {
//                    [toViewController.view setFrame:CGRectOffset(bounds, -bounds.size.width+self.yOffset, 0)];
//                }
//            }
            [transitionContext completeTransition:!self.wasCancelled];

        }];
    }
    
    
}

- (void)animationEnded:(BOOL) transitionCompleted {
    NSLog(@"Animation Ended");
}

@end
