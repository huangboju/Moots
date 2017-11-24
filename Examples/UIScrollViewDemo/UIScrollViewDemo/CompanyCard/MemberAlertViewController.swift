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

        
        let item = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showAlertAction))
        let item1 = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showPriceAction))
        
        navigationItem.rightBarButtonItems = [item, item1]
    }

    @objc
    func testAction() {
        print("aaaa")
    }
    
    @objc
    func showPriceAction() {
        let priceAlert = MemberPriceAlert()
        priceAlert.show()
    }

    @objc
    func showAlertAction() {
        let alert = MemberComponentAlertView()
//        let alert = MemberAlertView()
        alert.show()
    }
}
