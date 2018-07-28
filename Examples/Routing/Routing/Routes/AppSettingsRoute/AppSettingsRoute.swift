//
//  AppSettingsRoute.swift
//  Routing
//
//  Created by 黄伯驹 on 2018/7/28.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

protocol AppSettingsRoute {
    func openAppSettings()
}

extension AppSettingsRoute {
    func openAppSettings() {
        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
}
