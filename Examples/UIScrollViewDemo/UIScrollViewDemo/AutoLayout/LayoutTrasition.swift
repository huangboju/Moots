//
//  LayoutTrasition.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/7/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class LayoutTrasition: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        let button = UIButton()
        button.backgroundColor = UIColor.red
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.height.width.equalTo(80)
            make.center.equalTo(view)
        }
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    @objc func buttonAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            sender.snp.updateConstraints { (make) in
                make.height.width.equalTo(sender.isSelected ? 200 : 80)
                self.view.layoutIfNeeded()
            }
        }, completion: nil)
    }
}
