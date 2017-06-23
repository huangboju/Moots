//
//  RulerControllerWithLayout.swift
//  UIScrollViewDemo
//
//  Created by 伯驹 黄 on 2017/6/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class RulerControllerWithLayout: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = UIColor.white

        let rulerView = RulerView1(origin: CGPoint(x: 0, y: 100))

        view.addSubview(rulerView)

        let items = (1...30).map { "\($0)" }
        let daypicker = DayPicker(origin: CGPoint(x: 0, y: 400), items: items)
        view.addSubview(daypicker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
