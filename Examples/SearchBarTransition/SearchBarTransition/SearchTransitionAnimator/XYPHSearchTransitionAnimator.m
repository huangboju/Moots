//
//  SearchTransitionAnimator.m
//  SearchBarTransition
//
//  Created by 黄伯驹 on 02/02/2018.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

#import "XYPHSearchTransitionAnimator.h"

#import "XYPHSearchPushTranstion.h"
#import "XYPHSearchPopTranstion.h"

@implementation XYPHSearchTransitionAnimator

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        UISearchBar *searchBar = (UISearchBar *)[fromVC.view viewWithTag:100];
        [searchBar setShowsCancelButton:YES animated:YES];
        return [XYPHSearchPushTranstion new];
    }
    UISearchBar *searchBar = (UISearchBar *)[toVC.view viewWithTag:100];
    [searchBar setShowsCancelButton:NO animated:YES];
    return [XYPHSearchPopTranstion new];
}

@end
