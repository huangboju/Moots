//
//  Row.swift
//  FormView
//
//  Created by 黄伯驹 on 20/01/2018.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

struct NoneItem {}

public protocol Updatable: class {
    
    associatedtype ViewData
    func update(viewData: ViewData)
}

extension Updatable {
    func update(viewData: NoneItem) {}
}

public protocol FormCellable {}
extension UITableViewCell: FormCellable {}
extension UICollectionViewCell: FormCellable {}

public protocol RowType {
    
    var tag: RowTag { get }

    var cellClass: AnyClass { get }

    func update(cell: FormCellable)

    func cell<C: FormCellable>() -> C
    func cellItem<M>() -> M
}

public class Row<Cell> where Cell: Updatable & FormCellable {

    public let viewData: Cell.ViewData
    private var _cell: Cell?
    
    public init(viewData: Cell.ViewData, tag: RowTag = .none) {
        self.viewData = viewData
        self.tag = tag
    }
    
    public let tag: RowTag
    public let cellClass: AnyClass = Cell.self
    
    public func cell<C: FormCellable>() -> C {
        guard let cell = _cell as? C else {
            fatalError("cell 类型错误")
        }
        return cell
    }

    public func cellItem<M>() -> M {
        guard let cellItem = viewData as? M else {
            fatalError("cellItem 类型错误")
        }
        return cellItem
    }

    public func update(cell: FormCellable) {
        if let cell = cell as? Cell {
            self._cell = cell
            cell.update(viewData: viewData)
        }
    }
}

extension Row: RowType {}

public class RowTags {
    fileprivate init() {}
}

public class RowTag: RowTags {
    public let _key: String
    
    public init(_ key: String) {
        self._key = key
        super.init()
    }
}

extension RowTag: Hashable {
    public static func ==(lhs: RowTag, rhs: RowTag) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_key)
    }
}

public extension RowTags {
    static let none = RowTag("")
}
