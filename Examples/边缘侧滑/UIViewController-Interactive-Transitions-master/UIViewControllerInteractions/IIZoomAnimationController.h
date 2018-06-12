//
//  IIZoomAnimationController.h
//  InteractionDemo
//
//  Created by Daniel Broad on 04/07/2013.
//  Copyright (c) 2013 Dorada Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IIZoomAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

-(id) initToVC: (UIViewController*) to;

@end
