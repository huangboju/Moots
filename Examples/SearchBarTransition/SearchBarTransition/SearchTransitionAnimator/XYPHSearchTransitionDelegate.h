//
//  SearchTransitionDelegate.h
//  SearchBarTransition
//
//  Created by xiAo_Ju on 19/03/2018.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYPHSearchTransitionAnimator;

@interface XYPHSearchTransitionDelegate : NSObject

@property (class, nonatomic, readonly) XYPHSearchTransitionAnimator <UINavigationControllerDelegate>*transitionAnimator;

@end
