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

        let quartzImageView = QuartzImageView(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64))
        view.addSubview(quartzImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
