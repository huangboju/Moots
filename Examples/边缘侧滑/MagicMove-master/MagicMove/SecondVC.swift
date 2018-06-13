//
//  SecondVC.swift
//  MagicMove
//
//  Created by 黄伯驹 on 2018/6/13.
//  Copyright © 2018 Bourne. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}
