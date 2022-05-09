//
//  MainViewModel.swift
//  Routing
//
//  Created by 黄伯驹 on 2018/7/28.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class MainViewModel {
    private let router: MainRouter.Routes
    
    init(router: MainRouter.Routes) {
        self.router = router
    }
    
    func didTriggerSettingsEvent() {
        router.openSettingsModule()
    }
}
