//
//  CardViewController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/9/4.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue

        view.addSubview(UIView())

        let items = (0 ... 3).map { $0.description }
        let vipDetailHeader = LinerCardView(datas: items)
        vipDetailHeader.delgete = self

        vipDetailHeader.frame.origin.y = 100
        
        view.addSubview(vipDetailHeader)
    }
}

extension CardViewController: LinerCardViewDelegate {
    func didSelectItem(at index: Int, model: String) {
        print(index)
    }
}
