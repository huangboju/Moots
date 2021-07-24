//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by 黄伯驹 on 2021/7/17.
//

import SwiftUI

@main
struct LandmarksApp: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
