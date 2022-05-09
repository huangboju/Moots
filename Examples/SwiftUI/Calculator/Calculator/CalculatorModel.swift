//
//  CalculatorModel.swift
//  Calculator
//
//  Created by 黄伯驹 on 2021/11/13.
//

import SwiftUI
import Combine

class CalculatorModel: ObservableObject {

    @Published var brain: CalculatorBrain = .left("0")

    @Published var history: [CalculatorButtonItem] = []

    func apply(_ item: CalculatorButtonItem) {
        brain = brain.apply(item: item)
        history.append(item)
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
    }

    // 1
    var historyDetail: String {
        history.map { $0.description }.joined()
    }
    // 2
    var temporaryKept: [CalculatorButtonItem] = []
    // 3
    var totalCount: Int {
        history.count + temporaryKept.count
    }
    // 4
    var slidingIndex: Float = 0 {
        didSet {
            keepHistory(upTo: Int(slidingIndex))
        }
    }

    func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "Out of index.")
        let total = history + temporaryKept
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        brain = history.reduce(CalculatorBrain.left("0")) {
            result, item in
            result.apply(item: item)
        }
    }
}
