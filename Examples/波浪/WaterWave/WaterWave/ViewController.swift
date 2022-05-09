//
//  ViewController.swift
//  WaterWave
//
//  Created by 伯驹 黄 on 16/9/29.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var data: [[UIViewController.Type]] = [
        [
            FirstViewController.self,
            SecondController.self,
            ThirdController.self,
            SCViewController.self
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wave"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.textLabel?.text = "\(data[indexPath.section][indexPath.row].classForCoder())"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let controller = data[indexPath.section][indexPath.row].init()
        controller.view.backgroundColor = UIColor.white
        controller.title = "\(controller.classForCoder)"
        navigationController?.pushViewController(controller, animated: true)
    }
}

