//
//  BezierController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class BezierController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let quartzBezierView = QuartzBezierView()
        view.addSubview(quartzBezierView)
        quartzBezierView.translatesAutoresizingMaskIntoConstraints = false
        quartzBezierView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzBezierView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzBezierView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        quartzBezierView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
