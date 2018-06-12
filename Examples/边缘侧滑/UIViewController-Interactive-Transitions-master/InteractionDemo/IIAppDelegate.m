//
//  IIAppDelegate.m
//  InteractionDemo
//
//  Created by Daniel Broad on 25/06/2013.
//  Copyright (c) 2013 Dorada Software Ltd. All rights reserved.
//

#import "IIAppDelegate.h"
#import "IIViewController.h"
#import "IIViewController2.h"
#import "IISwipeInteractiveTransition.h"
#import "IIZoomAnimationController.h"

@interface IIAppDelegate ()
@end

@implementation IIAppDelegate

+(IIAppDelegate*) sharedInstance {
    return (IIAppDelegate*) [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.viewOne = [[IIViewController alloc] init];
    self.viewOne.view.backgroundColor = [UIColor redColor];
    self.viewOne.title = @"Swipe Up";
    self.viewTwo = [[IIViewController2 alloc] init];
    self.viewTwo.view.backgroundColor = [UIColor yellowColor];
    
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.viewControllers = @[self.viewOne];
    
    self.window.rootViewController = tab;
    
    [self.window makeKeyAndVisible];
    
    self.transition = [[IISwipeInteractiveTransition alloc] initWithTabBarController:tab];
    self.transition.toPresent = [[UINavigationController alloc] initWithRootViewController:self.viewTwo];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
