//
//  ResizableImageVC.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2018/6/24.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class ResizableImageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red

        let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 56, height: 56))
        imageView.image = UIImage(named: "avatar_mask")
        
        view.addSubview(imageView)
    }
}
