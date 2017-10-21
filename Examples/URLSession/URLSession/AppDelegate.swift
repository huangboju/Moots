//
//  AppDelegate.swift
//  URLSession
//
//  Created by 伯驹 黄 on 2016/12/29.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window?.backgroundColor = UIColor.white
//        getData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pastechanged), name: .UIPasteboardChanged, object: nil)
        
        return true
    }

    func pastechanged(_ notification: Notification) {
        print(notification.object)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("🍀")
        print(url, sourceApplication ?? "😆", annotation)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        
        print("🍀")
        print(url, options)
        
        return true
    }

//    func getData() {
//
//        let documentsPath = Bundle.main.path(forResource: "test", ofType: "json")
//        let urlPath = URL(fileURLWithPath: documentsPath!)
//        do {
//            let data = try Data(contentsOf: urlPath)
//            guard let result = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                return
//            }
//
//            let apis = result["api"] as? [[String: String]]
//            let domains = result["domain"] as? [[String: String]]
//
//        } catch let error {
//            print("❌❌❌", error)
//        }
//    }

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
