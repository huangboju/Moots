//
//  SKUGraphCellModel.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/11/7.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation
import SwiftGraph

class SKUGraphCellModel: SKUCellModelPresenter {
    var selectedGoods: SkuGoods?

    let goodsMap: [Set<Variant>: SkuGoods]

    let sections: [SKUSectionModel]

    let cellHeight: CGFloat

    let allItems: [SKUItemCellModel]

    var selectedItemSet: Set<SKUItemCellModel> = []

    var isValid: Bool {
        selectedItemSet.count == sections.count
    }

    init(_ allVariant: GoodsAllVariant = GoodsAllVariant(), selectedGoods: SkuGoods? = nil) {
        self.selectedGoods = selectedGoods

        let stateMap: [Variant: VariantState]
        (stateMap, goodsMap) = Self.initMap(allVariant)
        sections = allVariant.variants.enumerated().map {
            SKUSectionModel(section: $0, variants: $1, stateMap: stateMap)
        }

        allItems = sections.flatMap { $0.items }

        cellHeight = SKUCellModel.countCellHeight(sections)

        // 注意需要先设置状态，updateHighlightItem中canSelected依赖status
        setDefaultStatus()

        updateHighlightItem()
    }

    func setDefaultStatus() {
        for item in allItems {
            item.setStatus(with: item.state.optimalStatus, isActivity: item.state.optimalActivity)
        }
    }

    func updateHighlightItem() {
        guard let selctedGoods = selectedGoods else { return }
        for item in allItems {
            guard item.canSelected, selctedGoods.variantSet.contains(item.variant) else { continue }

            item.isSelected = true
            add(item: item)
        }
    }

    func item(at indexPath: IndexPath) -> SKUItemCellModel {
        section(at: indexPath).items[indexPath.row]
    }

    func section(at indexPath: IndexPath) -> SKUSectionModel {
        sections[indexPath.section]
    }

    func didSelectItem(at indexPath: IndexPath) {
        let item = item(at: indexPath)
        if item.isSelected {
            item.isSelected = false
            remove(item: item)
        } else {
            removeItem(at: indexPath)
            item.isSelected = true
            add(item: item)
        }
    }

    func removeItem(at indexPath: IndexPath) {
        for item in sections[indexPath.section].items where item.isSelected {
            item.isSelected = false
            remove(item: item)
        }
    }

    func add(item: SKUItemCellModel) {
        selectedItemSet.insert(item)
        updateItemStatus(with: item)
    }

    func remove(item: SKUItemCellModel) {
        selectedItemSet.remove(item)
        updateItemStatus(with: item)
    }

    func updateItemStatus(with item: SKUItemCellModel) {
        setSelectedGoodsIfNeeded()
        setSelectedStatus(with: item)
    }

    func setSelectedStatus(with changedItem: SKUItemCellModel) {
        if selectedItemSet.isEmpty {
            setDefaultStatus()
            return
        }
        let selectedItemSets = selectedItemSets()
        for item in allItems where changedItem.indexPath.section != item.indexPath.section {
            var tuple = selectedItemSets[item.indexPath.section]
            if tuple.0.isEmpty {
                tuple.0 = item.state.goodsSet
            } else {
                tuple.0.formIntersection(item.state.goodsSet)
            }
            let status = VariantState.optimalStatus2(with: tuple.0)
            item.setStatus(with: status, isActivity: item.state.optimalActivity && tuple.1)
        }
    }

    func selectedItemSets() -> [(Set<SkuGoods>, Bool)] {
        var result: [(Set<SkuGoods>, Bool)] = Array(repeating: (Set<SkuGoods>(), false), count: sections.count)
        for section in 0 ..< result.count {
            var tuple: (Set<SkuGoods>, Bool) = ([], true)
            for item in selectedItemSet where item.indexPath.section != section {
                if tuple.0.isEmpty {
                    tuple.0 = item.state.goodsSet
                } else {
                    tuple.0.formIntersection(item.state.goodsSet)
                }
                tuple.1 = tuple.1 && item.state.optimalActivity
            }
            result[section] = tuple
        }
        return result
    }

    func setSelectedGoodsIfNeeded() {
        guard isValid, let goods = goodsMap[Set(selectedItemSet.map { $0.variant })] else {
            return
        }
        selectedGoods = goods
    }

    static func initMap(_ allVariant: GoodsAllVariant) -> ([Variant: VariantState], [Set<Variant>: SkuGoods]) {
        // 找出所有匹配规格中，状态rawValue最小的，用于规格的默认status
        // 找出是活动的规格
        var dict: [Variant: VariantState] = [:]
        var skuMap: [Set<Variant>: SkuGoods] = [:]
        for goods in allVariant.goodsList {
            for variant in goods.variants {
                if let state = dict[variant] {
                    state.goodsSet.insert(goods)
                } else {
                    let state = VariantState(with: goods)
                    dict[variant] = state
                }
                skuMap[goods.variantSet] = goods
            }
        }
        return (dict, skuMap)
    }
}
