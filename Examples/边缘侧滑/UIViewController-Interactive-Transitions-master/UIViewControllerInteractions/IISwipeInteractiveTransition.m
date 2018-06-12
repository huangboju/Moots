//
//  IIInteractiveTransition.m
//  InteractionDemo
//
//  Created by Daniel Broad on 25/06/2013.
//  Copyright (c) 2013 Dorada Software Ltd. All rights reserved.
//

#import "IISwipeInteractiveTransition.h"
#import "IISwipeAnimationController.h"

@interface IISwipeInteractiveTransition ()  <UIViewControllerTransitioningDelegate>
@property(nonatomic,assign) UITabBarController *parent;
@property(nonatomic,assign,getter = isInteractive) BOOL interactive;
@property(strong) IISwipeAnimationController *myAnimationController;
@end

@implementation IISwipeInteractiveTransition{
    CGPoint _firstPoint;
}

- (id)initWithTabBarController:(UITabBarController*) tab {
    self = [super init];
    if (self) {
        self.parent = tab;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.parent.tabBar addGestureRecognizer:pan];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gr {
    CGPoint position = [gr translationInView:self.parent.view];
    CGFloat percent = fabs(position.y/self.parent.view.bounds.size.height);
    
    BOOL shouldBegin = YES;
    if ([self.delegate respondsToSelector:@selector(swipeInteractiveTransitionShouldBegin:)]) {
        shouldBegin = [self.delegate swipeInteractiveTransitionShouldBegin:self];
    }
    if (!shouldBegin) {
        return;
    }
    
    switch (gr.state) {
        case UIGestureRecognizerStateBegan:
            _firstPoint = [gr locationInView:gr.view];
            NSLog(@"Interaction begins %f",_firstPoint.y);
            self.interactive = YES;
            self.toPresent.modalPresentationStyle = UIModalPresentationCustom;
            [self.toPresent setTransitioningDelegate: self];
            [self.parent presentViewController:self.toPresent animated:YES completion:nil];
            self.myAnimationController.orientation = [self.parent interfaceOrientation];
            self.myAnimationController.wasCancelled = NO;
            self.myAnimationController.yOffset = 64-_firstPoint.y;
            if ([self.delegate respondsToSelector:@selector(swipeInteractiveTransitionDidBeginPresentation:)]) {
                [self.delegate swipeInteractiveTransitionDidBeginPresentation:self];
            }
            break;
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition: (percent <= 0.0) ? 0.0 : percent];
            break; }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if(percent < 0.25 || [gr state] == UIGestureRecognizerStateCancelled) {
                NSLog(@"Interaction cancelled");
                self.completionSpeed = 0.5f;
                self.myAnimationController.wasCancelled = YES;
                [self cancelInteractiveTransition];
                if ([self.delegate respondsToSelector:@selector(swipeInteractiveTransitionDidCancelPresentation:)]) {
                    [self.delegate swipeInteractiveTransitionDidCancelPresentation:self];
                }
            } else {
                self.completionSpeed = 1.0f;
                self.myAnimationController.wasCancelled = NO;
                NSLog(@"Interaction completed");
                [self finishInteractiveTransition];
                if ([self.delegate respondsToSelector:@selector(swipeInteractiveTransitionDidPresent:)]) {
                    [self.delegate swipeInteractiveTransitionDidPresent:self];
                }
            }
            self.interactive = NO;
        default:
        break;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UINavigationController *)presenting sourceController:(UIViewController *)source {
    self.myAnimationController = [[IISwipeAnimationController alloc] initToVC:presented];
    self.myAnimationController.orientation = [self.parent interfaceOrientation];
    return self.myAnimationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.myAnimationController = [[IISwipeAnimationController alloc] initToVC:dismissed];
    self.myAnimationController.orientation = [self.parent interfaceOrientation];
    return self.myAnimationController;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    if (self.interactive) {
        return self;
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

@end