//
//  ChildViewController.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 10/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class TableViewController: SafeAreaViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.register(TableViewCell.self,
                           forCellReuseIdentifier: String(describing: TableViewCell.self))
        tableView.register(TableViewHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: String(describing: TableViewHeaderFooterView.self))
        return tableView
    }()
    
    lazy var tableViewSectionItems: [TableViewSectionItem] = {
        return TableViewSectionItemsFactory.sectionItems(for: tableView)
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .grayBackgroundColor
        view.addSubview(tableView)
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - UITableViewDelegate

extension TableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let sectionItem = tableViewSectionItems[indexPath.section]
        sectionItem.cellItems.enumerated().forEach { (offset, cellItem) in
            if offset == indexPath.row {
                cellItem.enabled = cellItem.switchable ? !cellItem.enabled : true
                cellItem.selectionHandler?()
            }
            else {
                cellItem.enabled = false
            }
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionItem = tableViewSectionItems[section]
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: TableViewHeaderFooterView.self))
            as! TableViewHeaderFooterView
        view.customLabel.text = sectionItem.title
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSectionItems.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = tableViewSectionItems[section]
        return sectionItem.cellItems.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let view = view as! UITableViewHeaderFooterView
        view.backgroundColor = UIColor.clear
        view.backgroundView?.backgroundColor = UIColor.clear
        view.contentView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionItem = tableViewSectionItems[section]
        return sectionItem.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellItem = tableViewSectionItems[indexPath.section].cellItems[indexPath.row]
        return cellItem.height
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellItem = tableViewSectionItems[indexPath.section].cellItems[indexPath.row]
        if cellItem.custom {
            let identifier = String(describing: TableViewCell.self)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TableViewCell
            cell.selectionStyle = .none
            cell.customLabel.text = cellItem.title
            return cell
        }
        else {
            let identifier = String(describing: UITableViewCell.self)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as UITableViewCell
            cell.selectionStyle = .none
            cell.textLabel?.text = cellItem.title
            cell.accessoryType =  cellItem.enabled ? .checkmark : .none
            return cell
        }
    }
}
