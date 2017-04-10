//
//  LinesController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class LinesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let quartzLineView = QuartzLineView(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64))
        view.addSubview(quartzLineView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
