//
//  VisionMenuVC.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2022/6/4.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

class VisionMenuVC: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var data: [[UIViewController.Type]] = [
        [
            BarcodesVisionVC.self,
            FaceMaskViewController.self,
            FaceTrackVC.self
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(classForCoder)"
        
        tableView.register(AutoLayoutMainCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}

extension VisionMenuVC: UITableViewDataSource {
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

extension VisionMenuVC: UITableViewDelegate {
    
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
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        }
    }
}
