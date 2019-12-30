//
//  RectanglesController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class RectanglesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let quartzLineView = QuartzRectView()
        view.addSubview(quartzLineView)
        quartzLineView.translatesAutoresizingMaskIntoConstraints = false
        quartzLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzLineView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        quartzLineView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
