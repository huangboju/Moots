//
//  EllipseArcController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class EllipseArcController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let quartzEllipseArcView = QuartzEllipseArcView()
        view.addSubview(quartzEllipseArcView)
        quartzEllipseArcView.translatesAutoresizingMaskIntoConstraints = false
        quartzEllipseArcView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzEllipseArcView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzEllipseArcView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        quartzEllipseArcView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
