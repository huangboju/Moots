//
//  ContentView.swift
//  Calculator
//
//  Created by 黄伯驹 on 2021/10/29.
//

import SwiftUI

struct ContentView: View {

    //    @State private var brain: CalculatorBrain = .left("0")

    @EnvironmentObject var model: CalculatorModel

    @State private var editingHistory = false

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button("操作履历: \(model.history.count)") {
                self.editingHistory = true
            }.sheet(isPresented: self.$editingHistory) {
                HistoryView(model: self.model)
            }
            Text(model.brain.output)
                .font(.system(size: 76))
                .lineLimit(1)
                .padding(.trailing, 24)
                .minimumScaleFactor(0.5)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            CalculatorButtonPad()
                .padding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .dark)
            .environmentObject(CalculatorModel())
    }
}
