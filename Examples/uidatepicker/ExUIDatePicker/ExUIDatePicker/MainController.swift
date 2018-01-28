//
//  MainController.swift
//  ExUIDatePicker
//
//  Created by 黄伯驹 on 27/01/2018.
//  Copyright © 2018 hsin. All rights reserved.
//

import UIKit

class BaseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initSubviews()
    }
    
    func initSubviews() {}
}

class MainCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset = .zero
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
    }
}

class MainController: UIViewController {

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var data: [[UIViewController.Type]] = [
        [
            ViewController.self,
            InputBarController.self
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(classForCoder)"
        
        tableView.register(MainCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }

}

extension MainController: UITableViewDataSource {
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

extension MainController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "\(data[indexPath.section][indexPath.row].classForCoder())"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let controllerName = "\(data[indexPath.section][indexPath.row].classForCoder())"
        if let controller = controllerName.fromClassName() as? UIViewController {
            controller.title = controllerName
            controller.hidesBottomBarWhenPushed = true
            controller.view.backgroundColor = .white
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension String {
    func fromClassName() -> NSObject {
        let className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + self
        let aClass = NSClassFromString(className) as! UIViewController.Type
        return aClass.init()
    }
}
