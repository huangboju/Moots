//
//  AppState.swift
//  PokeMaster
//
//  Created by 黄伯驹 on 2022/1/23.
//

import SwiftUI

struct AppState {
    var settings = Settings()
}

extension AppState {
    struct Settings {
        
        var loginUser: User?
        
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        
        var accountBehavior = AccountBehavior.login
        
        var email = ""
        var password = ""
        var verifyPassword = ""
        
        
        enum Sorting: CaseIterable {
            case id, name, color, favorite
        }
        
        var showEnglishName = true
        var sorting = Sorting.id
        var showFavoriteOnly = false
    }
}


extension AppState {
    
}

