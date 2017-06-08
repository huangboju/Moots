//
//  MootsControllerWithLayout.swift
//  UIScrollViewDemo
//
//  Created by 伯驹 黄 on 2017/6/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class MootsControllerWithLayout: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = UIColor.white

        let rulerView = RulerView1(origin: CGPoint(x: 0, y: 100))

        view.addSubview(rulerView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
