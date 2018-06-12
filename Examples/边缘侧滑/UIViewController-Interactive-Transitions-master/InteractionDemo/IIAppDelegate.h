//
//  IIAppDelegate.h
//  InteractionDemo
//
//  Created by Daniel Broad on 25/06/2013.
//  Copyright (c) 2013 Dorada Software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IIViewController,IIViewController2,IISwipeInteractiveTransition;

@interface IIAppDelegate : UIResponder <UIApplicationDelegate>

+(IIAppDelegate*) sharedInstance;

@property (strong, nonatomic) UIWindow *window;
@property (strong) IIViewController *viewOne;
@property (strong) IIViewController2 *viewTwo;
@property (strong) IISwipeInteractiveTransition *transition;
@end
