//
//  AppDelegate.swift
//  UIScrollViewDemo
//
//  Created by 伯驹 黄 on 2016/11/29.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

let UIFontMake: (CGFloat) -> UIFont = { UIFont.systemFont(ofSize: $0) }
let UIFontBoldMake: (CGFloat) -> UIFont = { UIFont.boldSystemFont(ofSize: $0) }

let SCREEN_WIDTH = UIScreen.main.bounds.width
let PADDING: CGFloat = 16


import UIKit

enum ValidateType {
    case email, phoneNumber, idCard, password, number, englishName
}

extension String {
    func validate(with type: ValidateType, autoShowAlert: Bool = true) -> Bool {
        let regular: String
        switch type {
        case .email:
            regular = "^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$"
        case .phoneNumber:
            regular = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0-9])\\d{8}$"
        case .idCard:
            regular = "^(^\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$"
        case .number:
            regular = "^\\d+(\\.\\d+)?$"
        case .password:
            regular = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,20}"
        case .englishName:
            regular = "^[a-zA-Z\\u4E00-\\u9FA5]{2,20}"
        }
        let regexEmail = NSPredicate(format: "SELF MATCHES %@", regular)
        if regexEmail.evaluate(with: self) {
            return true
        } else {
            return false
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

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

