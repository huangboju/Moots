//
//  MenuViewController.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 11/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

// https://medium.com/rosberryapps/ios-safe-area-ca10e919526f

import UIKit

class MainViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        return tableView
    }()
    
    lazy var tableViewSectionItems: [TableViewSectionItem] = {
        let sectionItem = TableViewSectionItem()
        sectionItem.cellItems = [
            TableViewCellItem(title: "Touch View", selectionHandler: { [unowned self] in
                self.navigationController?.pushViewController(TouchViewController(), animated: true)
            }),
            TableViewCellItem(title: "Scroll View", selectionHandler: { [unowned self] in
                self.navigationController?.pushViewController(ScrollContainerViewController(), animated: true)
            }),
            TableViewCellItem(title: "Table View", selectionHandler: { [unowned self] in
                self.navigationController?.pushViewController(TableViewController(), animated: true)
            }),
            TableViewCellItem(title: "Collection View", selectionHandler: { [unowned self] in
                self.navigationController?.pushViewController(CollectionViewController(), animated: true)
            })
        ]
        return [sectionItem]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Safe Area Example"
        view.addSubview(tableView)
    }
    
    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableViewSectionItems[indexPath.section].cellItems.enumerated()
            .filter { (offset, _) -> Bool in
                return offset == indexPath.row
            }
            .forEach { (offset, cellItem) in
                cellItem.selectionHandler?()
        }
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionItem = tableViewSectionItems[section]
        return sectionItem.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSectionItems.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = tableViewSectionItems[section]
        return sectionItem.cellItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellItem = tableViewSectionItems[indexPath.section].cellItems[indexPath.row]
        let identifier = String(describing: UITableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as UITableViewCell
        cell.textLabel?.text = cellItem.title
        return cell
    }
}
