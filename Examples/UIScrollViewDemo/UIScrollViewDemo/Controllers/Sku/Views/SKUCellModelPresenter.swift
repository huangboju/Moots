//
//  SKUCellModelPresenter.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/11/7.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

protocol SKUCellModelPresenter {

    var selectedGoods: SkuGoods? { set get }

    var cellHeight: CGFloat { get }

    var isValid: Bool { get }

    var sections: [SKUSectionModel] { get }

    func item(at indexPath: IndexPath) -> SKUItemCellModel

    func section(at indexPath: IndexPath) -> SKUSectionModel

    func didSelectItem(at indexPath: IndexPath)
}
