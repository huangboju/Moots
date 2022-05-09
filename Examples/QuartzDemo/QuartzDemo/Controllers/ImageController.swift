//
//  ImageController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class ImageController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let quartzImageView = QuartzImageView()
        view.addSubview(quartzImageView)
        quartzImageView.translatesAutoresizingMaskIntoConstraints = false
        quartzImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzImageView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        quartzImageView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
