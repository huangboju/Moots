//
//  HZUIHelper.swift
//  HtinnsFlat
//
//  Created by 黄伯驹 on 2017/11/2.
//  Copyright © 2017年 hangting. All rights reserved.
//

import UIKit

struct NoneItem {}

protocol Updatable: class {
    
    associatedtype ViewData
    
    func update(viewData: ViewData)
}

extension Updatable {
    func update(viewData: NoneItem) {}
}

protocol RowType {
    
    var tag: String { get }
    
    var reuseIdentifier: String { get }
    var cellClass: AnyClass { get }
    
    func update(cell: UITableViewCell)
    
    
    func cell<T: UITableViewCell>() -> T
}

class Row<Cell> where Cell: Updatable, Cell: UITableViewCell {

    let tag: String
    
    let viewData: Cell.ViewData
    let reuseIdentifier = "\(Cell.classForCoder())"
    let cellClass: AnyClass = Cell.self

    init(viewData: Cell.ViewData, tag: String = "") {
        self.viewData = viewData
        self.tag = tag
    }
    
    func cell<T: UITableViewCell>() -> T {
        guard let cell = _cell as? T else {
            fatalError("cell 类型错误")
        }
        return cell
    }

    private var _cell: Cell?

    func update(cell: UITableViewCell) {
        if let cell = cell as? Cell {
            self._cell = cell
            cell.update(viewData: viewData)
        }
    }
}

extension Row: RowType {}


