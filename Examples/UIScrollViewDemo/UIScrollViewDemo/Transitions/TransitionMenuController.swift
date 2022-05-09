//
//  TransitionMenuController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/12.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

// https://blog.csdn.net/tianweitao/article/details/80314598
// http://biuer.club/2018/02/28/UIModalPresentationStyle-%E5%90%84%E7%A7%8D%E7%B1%BB%E5%9E%8B%E7%9A%84%E5%8C%BA%E5%88%AB/

class TransitionMenuController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var data: [[UIViewController.Type]] = [
        [
            CrossDissolveFirstViewController.self,
            SwipeFirstViewController.self,
            CustomPresentationFirstViewController.self,
            AdaptivePresentationFirstViewController.self,
            SlideTransitionTabBarVC.self
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(classForCoder)"
        
        tableView.register(AutoLayoutMainCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}

extension TransitionMenuController: UITableViewDataSource {
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

extension TransitionMenuController: UITableViewDelegate {
    
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
            show(controller, sender: nil)
        }
    }
}
