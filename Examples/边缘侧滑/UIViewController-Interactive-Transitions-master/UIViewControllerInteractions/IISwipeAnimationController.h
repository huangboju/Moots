//
//  IISwipeAnimatonController.h
//  InteractionDemo
//
//  Created by Daniel Broad on 11/07/2013.
//  Copyright (c) 2013 Dorada Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IISwipeInteractiveTransition;

@interface IISwipeAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

-(id) initToVC: (UIViewController*) to;

@property (assign) BOOL wasCancelled;
@property (assign) CGFloat yOffset;
@property (assign) UIInterfaceOrientation orientation;

@end
