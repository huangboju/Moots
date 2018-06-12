//
//  ChildViewController.h
//  Container Transitions
//
//  Created by Joachim Bondo on 30/04/2014.
//  Copyright (c) 2014 Joachim Bondo. All rights reserved.
//

#import <UIKit/UIKit.h>

/// A minimalistic view controller class, the perfect child view controller for testing view controller containment.
@interface ChildViewController : UIViewController

/** When the view is instantiated, this color will be applied as the view's backgroundColor and tintColor.
 @discussion This allows us to set up the view styling without necessarily having to instantiate the view.
 */
@property (nonatomic, strong) UIColor *themeColor;

@end
