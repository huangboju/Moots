//
//  SettingsRoute.swift
//  Routing
//
//  Created by 黄伯驹 on 2018/7/28.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import Foundation

protocol SettingsRoute {
    var settingsTransition: Transition { get }
    func openSettingsModule()
}

extension SettingsRoute where Self: RouterProtocol {
    func openSettingsModule() {
        let module = SettingsModule()
        let transition = settingsTransition // it's a calculated property so I saved it to the variable in order to have one instance
        module.router.openTransition = transition
        open(module.viewController, transition: transition)
    }
}
