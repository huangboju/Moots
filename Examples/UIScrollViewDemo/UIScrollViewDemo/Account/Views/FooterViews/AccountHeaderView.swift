//
//  AccountHeaderView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class AccountHeaderView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "img_account_logo"))
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 120))
        
        backgroundColor = .white

        addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.center = center
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
