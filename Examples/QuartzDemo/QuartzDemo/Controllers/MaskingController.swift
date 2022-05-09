//
//  MaskingController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class MaskingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let quartzMaskingView = QuartzMaskingView()
        view.addSubview(quartzMaskingView)
        quartzMaskingView.translatesAutoresizingMaskIntoConstraints = false
        quartzMaskingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzMaskingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzMaskingView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        quartzMaskingView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
