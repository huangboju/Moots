//
//  HiddenLayoutTestController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/16.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class HiddenLayoutTestController: UIViewController {
    
    let secondLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        let superView = UIView()
        superView.backgroundColor = .lightGray
        view.addSubview(superView)
        superView.translatesAutoresizingMaskIntoConstraints = false
        superView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        superView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        let firstLabel = UILabel()
        firstLabel.text = "今天天气好晴朗"
        firstLabel.backgroundColor = .red
        superView.addSubview(firstLabel)
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLabel.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        firstLabel.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        firstLabel.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true

        secondLabel.text = "今天下雨了"
        superView.addSubview(secondLabel)
        secondLabel.backgroundColor = .blue
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        secondLabel.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        secondLabel.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 10).isActive = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        secondLabel.isHidden = !secondLabel.isHidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
