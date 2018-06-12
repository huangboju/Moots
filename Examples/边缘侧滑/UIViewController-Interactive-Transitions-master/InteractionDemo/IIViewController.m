//
//  IIViewController.m
//  InteractionDemo
//
//  Created by Daniel Broad on 25/06/2013.
//  Copyright (c) 2013 Dorada Software Ltd. All rights reserved.
//

#import "IIViewController.h"
#import "IIViewController2.h"

#import "IIAppDelegate.h"
#import "IIZoomAnimationController.h"

@interface IIViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation IIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(show2:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) show2: (id) sender {
    UIViewController *toShow = [IIAppDelegate sharedInstance].viewTwo;
    toShow.modalPresentationStyle = UIModalPresentationCustom;
    toShow.transitioningDelegate = self;
    [self presentViewController:toShow animated:YES completion:^{
        
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UINavigationController *)presenting sourceController:(UIViewController *)source {
    return [[IIZoomAnimationController alloc] initToVC:presented];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[IIZoomAnimationController alloc] initToVC:dismissed];
}
@end
