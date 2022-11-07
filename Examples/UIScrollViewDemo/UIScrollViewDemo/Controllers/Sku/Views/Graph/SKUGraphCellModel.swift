//
//  SKUGraphCellModel.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/11/7.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation
import SwiftGraph

class SKUGraphCellModel {

//    let graph: WeightedGraph<Variant, Set<SkuGoods>>
//
//    let sections: [SKUSectionModel]
//
//    let cellHeight: CGFloat
//
//    init(_ allVariant: GoodsAllVariant = GoodsAllVariant(), selectedGoods: SkuGoods? = nil) {
//        graph = Backtrace(allVariant).graph
//    }

}


class Backtrace {
    let graph: WeightedGraph<Variant, Set<SkuGoods>>

    private var path: [Variant] = []

    init(_ allVariant: GoodsAllVariant) {
        let vertices = allVariant.variants.flatMap { variants in
            variants.values.map { value in Variant(id: variants.id, name: variants.name, value: value) }
        }
        graph = WeightedGraph<Variant, Set<SkuGoods>>(vertices: vertices)
        backtrace(allVariant, start: 0)
    }

    func backtrace(_ allVariant: GoodsAllVariant, start: Int) {
        if path.count == 2 {
            let pathSet = Set(path)
            let result = allVariant.goodsList.filter { pathSet.isSubset(of: $0.variantSet) }
            graph.addEdge(from: path[0], to: path[1], weight: Set(result))
            return
        }

        for i in start ..< allVariant.variants.count {
            let variant = allVariant.variants[i]
            for value in variant.values {
                path.append(Variant(id: variant.id, name: variant.name, value: value))
                backtrace(allVariant, start: i + 1)
                path.removeLast()
            }
        }
    }
}
