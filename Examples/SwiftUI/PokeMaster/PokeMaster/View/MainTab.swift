//
//  MainTab.swift
//  PokeMaster
//
//  Created by 黄伯驹 on 2022/1/23.
//

import SwiftUI

struct MainTab: View {
    var body: some View {
        TabView {
            PokemonRootView()
                .tabItem {
                    Image(systemName: "list.bullet.below.rectangle")
                    Text("列表")
                }
            
            SettingRootView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("设置")
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
