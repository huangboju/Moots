//
//  SettingsModule.swift
//  Routing
//
//  Created by 黄伯驹 on 2018/7/28.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

protocol SettingsModuleInput: class {}

protocol SettingsModuleOutput: class {}

final class SettingsModule {
    var input: SettingsModuleInput {
        return viewModel
    }
    
    var output: SettingsModuleOutput? {
        set {
            viewModel.output = newValue
        }
        get {
            return viewModel.output
        }
    }
    
    let router: SettingsRouter
    let viewController: SettingsViewController
    
    private let viewModel: SettingsViewModel
    
    init() {
        let router = SettingsRouter()
        let viewModel = SettingsViewModel(router: router)
        let viewController = SettingsViewController(viewModel: viewModel)
        router.viewController = viewController
        
        self.router = router
        self.viewController = viewController
        self.viewModel = viewModel
    }
}
