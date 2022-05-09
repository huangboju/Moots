//
//  PokeMasterApp.swift
//  PokeMaster
//
//  Created by 黄伯驹 on 2021/11/14.
//

import SwiftUI

@main
struct PokeMasterApp: App {
    var body: some Scene {
        WindowGroup {
            MainTab().environmentObject(Store())
        }
    }
}
