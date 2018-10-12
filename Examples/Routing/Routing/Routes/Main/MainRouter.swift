//
//  MainRouter.swift
//  Routing
//
//  Created by 黄伯驹 on 2018/7/28.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

class MainRouter: Router<MainViewController>, MainRouter.Routes {
    typealias Routes = SettingsRoute & NoInternetConnectionRoute & AppSettingsRoute
    
    var settingsTransition: Transition {
        switch selectedIndex {
        case 0: return PushTransition()
        case 1: return ModalTransition()
        case 2: return ModalTransition(animator: FadeAnimator())
        case 3: return PushTransition(animator: FadeAnimator())
        default: return PushTransition()
        }
    }
    
    private var selectedIndex: Int {
        return UserDefaults.standard.value(forKey: "index") as? Int ?? 0
    }
}
