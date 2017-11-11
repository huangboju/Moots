//
//  MemberAlertViewController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/10.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MemberAlertViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showAlertAction))
    }

    @objc
    func showAlertAction() {
        let alert = MemberAlertView()
        alert.show()
    }
}
