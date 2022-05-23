//
//  AutolayoutMenuController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/12.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class AutolayoutMenuController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var data: [[UIViewController.Type]] = [
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
            GroupingViews.self,
            ImageViewsAndAspectFitMode.self,
            AspectRatioImageView.self,
            DynamicTextAndReadability.self,
            WorkingWithScrollViews.self,
            AnimatingChangesViewController.self,
            SizeClassSpecificLayouts.self,
            UIKitDynamicsViewController.self,
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(classForCoder)"
        
        tableView.register(AutoLayoutMainCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}

extension AutolayoutMenuController: UITableViewDataSource {
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

extension AutolayoutMenuController: UITableViewDelegate {
    
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
