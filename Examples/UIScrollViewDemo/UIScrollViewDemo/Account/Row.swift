//
//  Row.swift
//  ConfigurableTableViewController
//
//  Created by Arkadiusz Holko on 03-01-16.
//  Copyright © 2016 Arkadiusz Holko. All rights reserved.
//

import UIKit

struct TmpItem {}

protocol Updatable: class {
    
    associatedtype ViewData
    
    func update(viewData: ViewData)
}

protocol RowType {

    var reuseIdentifier: String { get }
    var cellClass: AnyClass { get }

    func update(cell: UITableViewCell)
    
    
    func cell<T: UITableViewCell>() -> T
}

class Row<Cell> where Cell: Updatable, Cell: UITableViewCell {

    let viewData: Cell.ViewData
    let reuseIdentifier = "\(Cell.classForCoder())"
    let cellClass: AnyClass = Cell.self

    init(viewData: Cell.ViewData) {
        self.viewData = viewData
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

extension Row: RowType {

}
