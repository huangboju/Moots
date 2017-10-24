//
//  AutoLayoutMainController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class AutoLayoutBaseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubviews()
    }

    func initSubviews() {}
}

class AutoLayoutMainController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var data: [[UIViewController.Type]] = [
        [
            AutoLayoutController.self,
            CollectionViewSelfSizing.self,
            TableViewSelfsizing.self,
            LayoutTrasition.self,
            ExpandingCollectionViewController.self,
        ],
        [
            SimpleStackViewController.self,
            NestedStackViewController.self,
            DynamicStackViewController.self,
            TwoEqualWidthViewsController.self,
            TwoDifferentWidthViews.self,
            TwoViewsWithComplexWidths.self,
            SimpleLabelAndTextField.self,
            DynamicHeightLabelAndTextField.self,
            FixedHeightColumns.self,
            DynamicHeightColumns.self,
            TwoEqualWidthButtons.self,
            ThreeEqualWidthButtons.self,
            EqualWhiteSpace.self,
            ButtonsSizeClass.self,
            GroupingViews.self
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(classForCoder)"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}

extension AutoLayoutMainController: UITableViewDataSource {
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

extension AutoLayoutMainController: UITableViewDelegate {
    
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
