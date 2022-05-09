//
//  AnimationViewController.h
//  Animation
//
//  Created by Tim Moose on 6/18/13.
//  Copyright (c) 2013 Vast.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortNFilterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *layoutToggle;
- (IBAction)toggleLayout:(UISegmentedControl *)sender;
- (IBAction)shuffle;
- (IBAction)filter:(UIButton *)sender;
@end
