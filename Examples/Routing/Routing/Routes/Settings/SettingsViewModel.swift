//
//  SettingsViewModel.swift
//  Routing
//
//  Created by 黄伯驹 on 2018/7/28.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

final class SettingsViewModel {
    weak var output: SettingsModuleOutput?
    
    private let router: SettingsRouter.Routes
    
    // MARK: - Lifecycle
    
    init(router: SettingsRouter.Routes) {
        self.router = router
    }
    
    func didTriggerViewReadyEvent() {
        
    }
    
    func closeEvent() {
        router.close()
    }
}

// MARK: - SettingsModuleInput

extension SettingsViewModel: SettingsModuleInput {}
