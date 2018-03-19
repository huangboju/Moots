//
//  SearchTransitionDelegate.m
//  SearchBarTransition
//
//  Created by xiAo_Ju on 19/03/2018.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

#import "XYPHSearchTransitionDelegate.h"

#import "XYPHSearchTransitionAnimator.h"

@implementation XYPHSearchTransitionDelegate

+ (XYPHSearchTransitionAnimator <UINavigationControllerDelegate>*)transitionAnimator {
    static XYPHSearchTransitionAnimator *sharedDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDelegate = [XYPHSearchTransitionAnimator new];
    });
    return sharedDelegate;
}

@end
