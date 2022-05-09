//
//  FormView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class FormView: UITableView {
    
    var rows: [[RowType]] = [] {
        didSet {
            registerCells()
        }
    }

    convenience init(frame: CGRect) {
        self.init(frame: frame, style: .grouped)

        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 44

        dataSource = self
    }

    final func row(at indexPath: IndexPath) -> RowType {
        return rows[indexPath.section][indexPath.row]
    }
    
    final var tags: Set<String> {
        let _tags = rows.flatMap { $0 }.map { $0.tag }
        return Set(_tags)
    }
    
    final func cellBy<T: UITableViewCell>(tag: String) -> T {
        for section in rows {
            for row in section where row.tag == tag {
                guard let cell = row.cell() as? T else {
                    fatalError("cell不存在")
                }
                return cell
            }
        }
        fatalError("cell不存在")
    }

    final func tableHeaderView<T: UIView>() -> T? {
        guard let headerView = tableHeaderView as? T else {
            return nil
        }
        return headerView
    }

    final func tableFooterView<T: UIView>() -> T? {
        guard let footerView = tableFooterView as? T else {
            return nil
        }
        return footerView
    }

    private func registerCells() {
        rows.flatMap { $0 }
            .forEach { register($0.cellClass, forCellReuseIdentifier: $0.reuseIdentifier) }
    }
}

extension FormView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellConfigurator = row(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConfigurator.reuseIdentifier, for: indexPath)
        cellConfigurator.update(cell: cell)
        return cell
    }
}
