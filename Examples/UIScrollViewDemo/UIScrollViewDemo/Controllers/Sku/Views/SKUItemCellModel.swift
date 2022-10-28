//
//  SKUItemCellModel.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/10/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

class VariantState {

    var goodsMap: [Set<Variant>: SkuGoods]

    init (with sku: SkuGoods = SkuGoods()) {
        goodsMap = [sku.variantSet: sku]
    }

    private(set) lazy var optimalStatus: SKUItemStatus = {
        return Self.optimalStatus(with: Set(goodsMap.values.map { $0.status }))
    }()

    private(set) lazy var optimalActivity: Bool = {
        goodsMap.values.first(where: { $0.isActivity }) != nil
    }()

    static func optimalStatus(with set: Set<SkuGoods.Status>) -> SKUItemStatus {
        let sortedStatusList = set.sorted { $0.rawValue < $1.rawValue }
        guard let first = sortedStatusList.first else {
            return .unfound
        }
        switch first {
        case .normal:
            return .normal
        case .sellOut:
            return .sellOut
        case .notSale:
            return .notSale
        }
    }

    static func status(with status: SkuGoods.Status) -> SKUItemStatus {
        switch status {
        case .normal:
            return .normal
        case .sellOut:
            return .sellOut
        case .notSale:
            return .notSale
        }
    }
}

enum SKUItemStatus: Int {
    case normal = 1
    // 售罄
    case sellOut = 2
    // 下架
    case notSale = 3

    case unfound = 999
}

final class SKUItemCellModel: Hashable {

    private(set) var cellSize: CGSize = .zero

    let indexPath: IndexPath

    var isSelected = false

    var status: SKUItemStatus = .normal {
        didSet {
            if status == .unfound {
                isActivity = false
            }
        }
    }

    var id: String {
        variant.id
    }

    var name: String {
        variant.name
    }

    var value: String {
        variant.value
    }

    var canSelected: Bool {
        status == .normal || status == .sellOut
    }

    private(set) var isActivity = false

    let state: VariantState

    let variant: Variant

    let itemWidth: CGFloat

    init(variant: Variant, state: VariantState, indexPath: IndexPath) {
        self.state = state
        self.variant = variant
        self.indexPath = indexPath

        let font = UIFont.boldSystemFont(ofSize: 12)
        let stringWidth = variant.value.widthOfString(usingFont: font)
        itemWidth = ceil(stringWidth) + 24
        cellSize = CGSize(width: itemWidth, height: 28)
    }

    func setStatus(with status: SKUItemStatus, isActivity: Bool = false) {
        self.isActivity = isActivity
        // 13 = 10 (icon width) + 3 (spacing)
        cellSize.width = itemWidth + (isActivity ? 13 : 0)
        self.status = status
    }

    static func == (lhs: SKUItemCellModel, rhs: SKUItemCellModel) -> Bool {
        lhs.variant == rhs.variant
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(variant)
    }
}

private extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let frame = self.boundingRect(with: CGSize(width: 200, height: CGFloat.infinity),
                                      options: .usesLineFragmentOrigin,
                                      attributes: [.font: font],
                                      context: nil)
        return frame.size.width
    }
}
