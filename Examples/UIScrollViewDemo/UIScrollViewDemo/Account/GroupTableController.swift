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

    var items: [[RowType]] = []

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

    final func item(at indexPath: IndexPath) -> RowType {
        return items[indexPath.section][indexPath.row]
    }

    private func registerCells() {
        items.flatMap { $0 }.forEach { tableView.register($0.cellClass, forCellReuseIdentifier: $0.reuseIdentifier) }
    }
}

extension GroupTableController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellConfigurator = item(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConfigurator.reuseIdentifier, for: indexPath)
        cellConfigurator.update(cell: cell)
        return cell
    }
}

extension GroupTableController: UITableViewDelegate {}

