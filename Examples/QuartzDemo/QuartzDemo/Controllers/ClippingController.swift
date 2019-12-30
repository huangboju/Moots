//
//  ClippingController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class ClippingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let quartzClippingView = QuartzClippingView()
        view.addSubview(quartzClippingView)
        quartzClippingView.translatesAutoresizingMaskIntoConstraints = false
        quartzClippingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzClippingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzClippingView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        quartzClippingView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
