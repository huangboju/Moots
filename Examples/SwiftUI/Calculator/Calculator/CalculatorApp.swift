//
//  CalculatorApp.swift
//  Calculator
//
//  Created by 黄伯驹 on 2021/10/29.
//

import SwiftUI

@main
struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(CalculatorModel())
        }
    }
}
