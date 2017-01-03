//
//  ViewController.swift
//  TransitionsLibrary
//
//  Created by 伯驹 黄 on 16/8/30.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: view.frame.insetBy(dx: 50, dy: 100))
        button.backgroundColor = UIColor.red
        button.titleLabel?.font = UIFont.systemFont(ofSize: 500)
        button.setTitle("1", for: UIControlState())
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func action() {
        navigationController?.pushViewController(TestController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

