//
//  AppDelegate.swift
//  LazyLoad
//
//  Created by 伯驹 黄 on 2016/10/8.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        test()
        return true
    }
    
    func test() {
        var oneInt = 3
        var twoInt = 4
        SwapTwoValues(a: &oneInt, b: &twoInt)
        print("oneInt:\(oneInt),twoInt:\(twoInt)") // oneInt:3,twoInt:4
        
        var oneStr = "hello"
        var twoStr = "world"
        SwapTwoValues(a: &oneStr, b: &twoStr)
        print("oneStr:\(oneStr),twoStr:\(twoStr)")// oneStr:world,twoStr:hello
        
        var stack = Stack<String>() //要在类型名后面加<类型名>
        stack.push(item: "uno")
        stack.push(item: "dos")
        stack.push(item: "tres")
        stack.push(item: "cuatro")
        
        print(stack.pop())
        
        print("stack's top item is : \(stack.topItem!)")
        
        let value = findIndex([3.14159, 0.1, 0.25], valueToFind: 9.3)
        print(value)
        
        let stringIndex = findIndex(["Mike", "Malcolm", "Andrea"], valueToFind: "Andrea")
        print(stringIndex)
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

