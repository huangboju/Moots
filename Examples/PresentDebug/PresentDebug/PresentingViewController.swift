//
//  PresentingViewController.swift
//  PresentDebug
//
//  Created by xiAo_Ju on 2018/10/18.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

class PresentingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x7DE6C2)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.frame.origin.y = UIScreen.main.bounds.height - 400
        view.frame.size.height = 400
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nav = presentingViewController?.navigationController
        nav?.pushViewController(DetailViewController(), animated: true)
    }
}
