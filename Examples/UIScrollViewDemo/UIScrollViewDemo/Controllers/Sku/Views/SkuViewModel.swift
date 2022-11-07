//
//  SkuViewModel.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/10/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

public protocol FormViewModelable: AnyObject {
    var sections: [[RowType]] { get set }

    init(sectionCount: Int)

    func section(at sectionIndex: Int) -> [RowType]
    func replaceSection(at sectionIndex: Int, section: [RowType])
    func appendSection(section: [RowType])
    func insertSection(at sectionIndex: Int, section: [RowType])
    func removeSection(at sectionIndex: Int)
    func removeSectionObject(at sectionIndex: Int)
    func removeAllSection()
    func getSectionCount() -> Int
    func getLastSectionIndex() -> Int?

    func row(at indexPath: IndexPath) -> RowType
    func appendRow(at sectionIndex: Int, row: RowType)
    func appendRow(at sectionIndex: Int, rows: [RowType])
    func insertRow(at indexPath: IndexPath, row: RowType)
    func insertRow(at indexPath: IndexPath, rows: [RowType])
    func removeRow(at indexPath: IndexPath)
    func replaceRow(at indexPath: IndexPath, row: RowType)
    func getRowCount(at sectionIndex: Int) -> Int

    subscript<M>(_: IndexPath) -> M { get }

    func cellModel<M>(at indexPath: IndexPath) -> M
}

public extension FormViewModelable {
    // MARK: - section

    func section(at sectionIndex: Int) -> [RowType] {
        sections[sectionIndex]
    }

    func replaceSection(at sectionIndex: Int, section: [RowType]) {
        sections[sectionIndex] = section
    }

    func appendSection(section: [RowType]) {
        sections.append(section)
    }

    func insertSection(at sectionIndex: Int, section: [RowType]) {
        sections.insert(section, at: sectionIndex)
    }

    func removeSection(at sectionIndex: Int) {
        sections.remove(at: sectionIndex)
    }

    func removeSectionObject(at sectionIndex: Int) {
        sections[sectionIndex] = []
    }

    func removeAllSection() {
        sections = []
    }

    func getSectionCount() -> Int {
        sections.count
    }

    func getLastSectionIndex() -> Int? {
        !sections.isEmpty ? sections.count - 1 : nil
    }

    // MARK: - RowType

    func row(at indexPath: IndexPath) -> RowType {
        sections[indexPath.section][indexPath.row]
    }

    func appendRow(at sectionIndex: Int, row: RowType) {
        sections[sectionIndex].append(row)
    }

    func appendRow(at sectionIndex: Int, rows: [RowType]) {
        sections[sectionIndex].append(contentsOf: rows)
    }

    func insertRow(at indexPath: IndexPath, row: RowType) {
        sections[indexPath.section].insert(row, at: indexPath.row)
    }

    func insertRow(at indexPath: IndexPath, rows: [RowType]) {
        sections[indexPath.section].insert(contentsOf: rows, at: indexPath.row)
    }

    func removeRow(at indexPath: IndexPath) {
        sections[indexPath.section].remove(at: indexPath.row)
    }

    func replaceRow(at indexPath: IndexPath, row: RowType) {
        sections[indexPath.section][indexPath.row] = row
    }

    func getRowCount(at sectionIndex: Int) -> Int {
        sections[sectionIndex].count
    }

    // MARK: - CellModel
    subscript<M>(indexPath: IndexPath) -> M { sections[indexPath.section][indexPath.row].cellItem() }

    func cellModel<M>(at indexPath: IndexPath) -> M {
        sections[indexPath.section][indexPath.row].cellItem()
    }
}

open class TableViewModel: NSObject, FormViewModelable, UITableViewDataSource {
    open var sections: [[RowType]] = []

    required public init(sectionCount: Int = 0) {
        super.init()
        for _ in 0..<sectionCount {
            appendSection(section: [])
        }
    }

    open func registCell(in tableView: UITableView) {
        assert(false, "需要重写")
    }

    public final func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    public final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }

    public final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.row(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
        row.update(cell: cell)
        return cell
    }
}

class SkuViewModel: TableViewModel {

    var isEnable: Bool {
        if let cellModel = sKUCellModel {
            return cellModel.isValid && cellModel.selectedGoods?.status == .normal
        }
        return true
    }

    convenience init() {
        self.init(sectionCount: 1)

        let goodsInfoModel = GoodsInfoCellModel()
        let infoRow = Row<GoodsInfoCell>(viewData: goodsInfoModel)
        sections[0].append(infoRow)
    }

    func updateRows(with model: GoodsModel) {
        updateInfoRow(with: model)

        addSkuRowIfNeeded(with: model)
    }

    func updateInfoRow(with model: GoodsModel) {
        guard let first = model.goodsList.first else {
            return
        }
        let goodsInfoModel = refreshInfoRow(with: first)
        if let spu = model.goodsMap["633a6b9cf696fd0001445b41"], spu.status != .notSale {
            goodsInfoModel.shouldShowMainImage = false
        }
    }

    @discardableResult
    func refreshInfoRow(with model: SkuGoods) -> GoodsInfoCellModel {
        let goodsInfoModel: GoodsInfoCellModel = sections[0][0].cellItem()
        goodsInfoModel.sku = model
        return goodsInfoModel
    }

    func addSkuRowIfNeeded(with model: GoodsModel) {
        if model.variants.isEmpty { return }
        var selctedGoods: SkuGoods?
        if let goods = model.goodsMap["633a6b9cf696fd0001445b41"], goods.status != .notSale {
            selctedGoods = goods
        }
        let cellModel = SKUCellModel(model.goodsAllVariant, selectedGoods: selctedGoods)
        if let selctedGoods = cellModel.selectedGoods {
            refreshInfoRow(with: selctedGoods)
        }
        let skuRow: RowType = Row<SKUCell>(viewData: cellModel)
        sections[0].append(skuRow)
    }

    func row(at index: Int) -> RowType {
        row(at: IndexPath(row: index, section: 0))
    }

    func targetRow(with cls: UITableViewCell.Type) -> RowType? {
        for row in sections[0] where row.cellClass == cls {
            return row
        }
        return nil
    }
}

extension SkuViewModel {
    var infoCellModel: GoodsInfoCellModel? {
        let model: GoodsInfoCellModel? = targetRow(with: GoodsInfoCell.self)?.cellItem()
        return model
    }

    var sKUCellModel: SKUCellModelPresenter? {
        let model: SKUCellModelPresenter? = targetRow(with: SKUCell.self)?.cellItem()
        return model
    }
}
