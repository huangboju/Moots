//
//  InfiniteScrollViewController.swift
//  UIScrollViewDemo
//
//  Created by 伯驹 黄 on 2016/11/29.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class InfiniteScrollViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        automaticallyAdjustsScrollViewInsets = false

        let test = InfiniteScrollView(frame: view.bounds.insetBy(dx: 0, dy: 200))
        test.backgroundColor = UIColor.blue
        view.addSubview(test)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
