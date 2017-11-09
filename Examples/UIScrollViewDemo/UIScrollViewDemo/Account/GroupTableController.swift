//
//  GroupTableDetail.swift
//  ExampleApp
//
//  Created by 黄伯驹 on 2017/11/2.
//  Copyright © 2017年 Arkadiusz Holko. All rights reserved.
//

import UIKit

class GroupTableController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    var rows: [[RowType]] = [] {
        didSet {
            registerCells()
        }
    }
    
    final override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        initSubviews()

        registerCells()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    open func initSubviews() {}
    
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
        guard let headerView = tableView.tableHeaderView as? T else {
            return nil
        }
        return headerView
    }

    final func tableFooterView<T: UIView>() -> T? {
        guard let footerView = tableView.tableFooterView as? T else {
            return nil
        }
        return footerView
    }
    
    private func registerCells() {
        rows.flatMap { $0 }.forEach { tableView.register($0.cellClass, forCellReuseIdentifier: $0.reuseIdentifier) }
    }
}

extension GroupTableController: UITableViewDataSource {
    
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

extension GroupTableController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
