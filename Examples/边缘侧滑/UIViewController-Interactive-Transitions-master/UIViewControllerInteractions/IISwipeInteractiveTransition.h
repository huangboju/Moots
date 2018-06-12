//
//  IIInteractiveTransition.h
//  InteractionDemo
//
//  Created by Daniel Broad on 25/06/2013.
//  Copyright (c) 2013 Dorada Software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IISwipeInteractiveTransition;

@protocol IISwipeInteractiveTransitionProtocol <NSObject>
@optional
    -(void) swipeInteractiveTransitionDidBeginPresentation: (IISwipeInteractiveTransition*) swipe;
    -(void) swipeInteractiveTransitionDidCancelPresentation: (IISwipeInteractiveTransition*) swipe;
    -(void) swipeInteractiveTransitionDidPresent: (IISwipeInteractiveTransition*) swipe;
    -(BOOL) swipeInteractiveTransitionShouldBegin: (IISwipeInteractiveTransition*) swipe;
@end

@interface IISwipeInteractiveTransition : UIPercentDrivenInteractiveTransition

    - (instancetype)initWithTabBarController:(UITabBarController*) tab;

    @property(nonatomic,strong) UIViewController *toPresent;
    @property(weak) id<IISwipeInteractiveTransitionProtocol> delegate;

@end
