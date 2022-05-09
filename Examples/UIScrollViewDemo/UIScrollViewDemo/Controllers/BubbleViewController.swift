//
//  BubbleViewController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/15.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class BubbleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let imageview01 = UIImageView(frame: CGRect(x: 90, y: 190, width: 120, height: 180))
        imageview01.image = UIImage(named: "style")
        view.addSubview(imageview01)

        let imageview02 = UIImageView(frame: imageview01.frame)
        imageview02.image = UIImage(named: "icon_chat_right_bg")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 15)
        
        /// http://www.jianshu.com/p/a577023677c1
//        UIImage(named: "icon_chat_right_bg")?.resizableImage(withCapInsets: <#T##UIEdgeInsets#>, resizingMode: <#T##UIImageResizingMode#>)

        let layer = imageview02.layer
        layer.frame = CGRect(origin: .zero, size: imageview02.layer.frame.size)
        imageview01.layer.mask = layer
    }
}
