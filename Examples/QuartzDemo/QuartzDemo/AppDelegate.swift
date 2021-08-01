//
//  AppDelegate.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

// https://chengkang.me/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


        for i in 1..<4 {
            print(i)
        }

        [0, 4, 2, 0, 3, 4, 0]

        [
            [
                (26.508090614886733, 170.0),
                (39.04854368932038, 138.0),
                (51.58899676375404, 106.0),
                (64.1294498381877, 74.0)
            ],
            [
                (121.70379338175948, 106.0),
                (145.68146354587032, 138.0)
            ],
            [
                (171.80234201494045, 170.0),
                (196.9941449626489, 202.0)
            ],
            [
                (183.80471171729695, 170.0),
                (200.62120272783633, 138.0),
                (217.43769373837569, 106.0)
            ],
            [
                (242.47619047619048, 74.0)
            ],
            [
                (304.20628223159866, 106.0),
                (316.92311298640413, 138.0),
                (329.63994374120955, 170.0),
                (342.356774496015, 202.0)
            ]
        ]

        [
            (24.0, 176.4),
            (75.66666666666666, 44.56),
            (127.33333333333333, 113.51304347826087),
            (179.0, 179.14285714285714),
            (230.66666666666666, 80.82666666666667),
            (282.3333333333333, 50.96),
            (334.0, 180.97142857142856)
        ]

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

