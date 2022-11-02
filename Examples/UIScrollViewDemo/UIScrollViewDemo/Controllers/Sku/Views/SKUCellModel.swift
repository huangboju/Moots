//
//  SKUCellModel.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/10/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

class SKUSectionModel {
    let title: String
    let items: [SKUItemCellModel]

    init(section: Int, variants: Variants, stateMap: [Variant: VariantState]) {
        title = variants.name
        items = variants.values
            .map { Variant(id: variants.id, name: variants.name, value: $0) }
            .enumerated()
            .map {
                SKUItemCellModel(variant: $1,
                                         state: stateMap[$1] ?? VariantState(),
                                         indexPath: IndexPath(row: $0, section: section))
            }
    }
}

class SKUCellModel {
    let allVariant: GoodsAllVariant

    let cellHeight: CGFloat

    let sections: [SKUSectionModel]

    var selectedGoods: SkuGoods?

    var selectedItemSet: Set<SKUItemCellModel> = []

    // 后端计算好的sku组合goods
    let goodsMap: [Set<Variant>: SkuGoods]

    let allItems: [SKUItemCellModel]

    // 选中的规格数据要等于规格分类数才是有效的选择
    var isValid: Bool {
        selectedItemSet.count == sections.count
    }

    init(_ allVariant: GoodsAllVariant = GoodsAllVariant(), selectedGoods: SkuGoods? = nil) {
        self.allVariant = allVariant
        self.selectedGoods = selectedGoods
        let stateMap: [Variant: VariantState]
        (stateMap, goodsMap) = Self.initMap(allVariant)
        sections = allVariant.variants.enumerated().map {
            SKUSectionModel(section: $0, variants: $1, stateMap: stateMap)
        }

        allItems = sections.flatMap { $0.items }

        cellHeight = Self.countCellHeight(sections)
        // 注意需要先设置状态，updateHighlightItem中canSelected依赖status
        setDefaultStatus()

        updateHighlightItem()
    }

    static func initMap(_ allVariant: GoodsAllVariant) -> ([Variant: VariantState], [Set<Variant>: SkuGoods]) {
        // 找出所有匹配规格中，状态rawValue最小的，用于规格的默认status
        // 找出是活动的规格
        var dict: [Variant: VariantState] = [:]
        var skuMap: [Set<Variant>: SkuGoods] = [:]
        for goods in allVariant.goodsList {
            for variant in goods.variants {
                if let state = dict[variant] {
                    state.goodsMap[goods.variantSet] = goods
                } else {
                    let state = VariantState(with: goods)
                    dict[variant] = state
                }
                skuMap[goods.variantSet] = goods
            }
        }
        return (dict, skuMap)
    }

    func updateHighlightItem() {
        guard let selctedGoods = selectedGoods else { return }
        for item in allItems {
            guard item.canSelected, selctedGoods.variantSet.contains(item.variant) else { continue }

            item.isSelected = true
            add(item: item)
        }
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

    func item(at indexPath: IndexPath) -> SKUItemCellModel {
        section(at: indexPath).items[indexPath.row]
    }

    func section(at indexPath: IndexPath) -> SKUSectionModel {
        sections[indexPath.section]
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

    func setDefaultStatus() {
        for item in allItems {
            item.setStatus(with: item.state.optimalStatus, isActivity: item.state.optimalActivity)
        }
    }

    func setSelectedStatus(with changedItem: SKUItemCellModel) {
        if selectedItemSet.isEmpty {
            setDefaultStatus()
            return
        }
        let selectedItemSets = selectedItemSets()
        for item in allItems where changedItem.indexPath.section != item.indexPath.section {
            let result = selectedItemSets[item.indexPath.section]
            var tuple: (SKUItemStatus, Bool) = (.unfound, false)
            for (key, value) in item.state.goodsMap where result.0.isSubset(of: key) {
                let new = VariantState.status(with: value.status)
                tuple.0 = new.rawValue < tuple.0.rawValue ? new : tuple.0
                tuple.1 = item.state.optimalActivity && result.1
            }
            item.setStatus(with: tuple.0, isActivity: tuple.1)
        }
    }

    func setSelectedGoodsIfNeeded() {
        guard isValid, let goods = goodsMap[Set(selectedItemSet.map { $0.variant })] else {
            return
        }
        selectedGoods = goods
    }

    func selectedItemSets() -> [(Set<Variant>, Bool)] {
        var result: [(Set<Variant>, Bool)] = Array(repeating: (Set<Variant>(), false), count: sections.count)
        for section in 0 ..< result.count {
            var tuple: (Set<Variant>, Bool) = ([], true)
            for item in selectedItemSet where item.indexPath.section != section {
                tuple.0.insert(item.variant)
                tuple.1 = tuple.1 && item.state.optimalActivity
            }
            result[section] = tuple
        }
        return result
    }
}

extension SKUCellModel {

    private static func countCellHeight(_ sections: [SKUSectionModel]) -> CGFloat {
        if sections.isEmpty { return 0 }

        // header 30, footer 20, minSpacing 12 * (rowCount - 1), cell 28 * rowCount
        var height: CGFloat = 0
        let maxWidth = UIScreen.main.bounds.width - 16 * 2
        let stringInset: CGFloat = 12
        let cellSpacing: CGFloat = 12
        let cellLineSpacing: CGFloat = 12
        let cellHeight: CGFloat = 28
        let sectionHeaderHeight: CGFloat = 30
        let sectionFooterHeight: CGFloat = 20

        for section in sections {
            var rowCount: CGFloat = 1
            var curWidth: CGFloat = 0
            for item in section.items {
                let stringWidth = item.cellSize.width
                if (stringWidth + curWidth) > maxWidth {
                    rowCount += 1
                    curWidth = 0
                }
                curWidth += stringWidth + stringInset * 2 + cellSpacing
            }
            height += sectionHeaderHeight + sectionFooterHeight + rowCount * cellHeight + (rowCount - 1) * cellLineSpacing
        }
        return height
    }
}
