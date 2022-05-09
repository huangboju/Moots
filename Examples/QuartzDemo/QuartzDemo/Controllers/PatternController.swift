//
//  PatternController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class PatternController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let quartzPatternView = QuartzPatternView()
        view.addSubview(quartzPatternView)
        quartzPatternView.translatesAutoresizingMaskIntoConstraints = false
        quartzPatternView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzPatternView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzPatternView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        quartzPatternView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
