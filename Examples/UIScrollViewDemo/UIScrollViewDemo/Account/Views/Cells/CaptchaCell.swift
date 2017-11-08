//
//  CaptchaCell.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/6.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class CaptchaCell: TextFiledCell {
    private let rightView = UIButton()

    override func didInitialzed() {

        setRightView(with: rightView)
    }

    var captchaImage: UIImage? {
        didSet {
            rightView.setBackgroundImage(captchaImage, for: .normal)
        }
    }
}
