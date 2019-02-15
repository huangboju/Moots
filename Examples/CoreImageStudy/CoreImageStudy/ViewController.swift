//
//  ViewController.swift
//  CoreImageStudy
//
//  Created by 黄伯驹 on 2019/2/14.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var data: [[String]] = [ ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        let filterNames = CIFilter.filterNames(inCategory: kCICategoryBuiltIn) as [String]
        title = "CoreImage(\(filterNames.count))"
        data.append(filterNames)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = filterName(at: indexPath)
        cell.accessoryType = .disclosureIndicator
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: false) }
        let filterName = self.filterName(at: indexPath)
        let controller = FilterDetailVC()
        controller.filterName = filterName
        controller.hidesBottomBarWhenPushed = true
        controller.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelClicked))
        showDetailViewController(LandscapeNav(rootViewController: controller), sender: nil)
    }
    
    func filterName(at indexPath: IndexPath) -> String {
        return data[indexPath.section][indexPath.row]
    }
    
    func vcName(with filterName: String) -> String {
        return String(filterName[filterName.index(filterName.startIndex, offsetBy: 2)..<filterName.endIndex]) + "VC"
    }

    @objc
    func cancelClicked(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

