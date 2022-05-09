//
//  CalculatorButtonRow.swift
//  Calculator
//
//  Created by 黄伯驹 on 2021/10/30.
//

import SwiftUI

struct CalculatorButtonRow: View {
    //    @Binding var brain: CalculatorBrain
    let row: [CalculatorButtonItem]
    @EnvironmentObject var model: CalculatorModel

    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    backgroundColorName: item.backgroundColorName) {
                        //                    self.brain = self.brain.apply(item: item)
                        self.model.apply(item)
                    }
            }
        }
    }
}

//struct CalculatorButtonRow_Previews: PreviewProvider {
//    let row: [CalculatorButtonItem] = [
//        .digit(1),
//        .digit(2),
//        .digit(3),
//        .op(.plus),
//    ]
//
//    static var previews: some View {
//        CalculatorButtonRow(row: row)
//    }
//}
