//
//  CustomNav.swift
//  PresentDebug
//
//  Created by xiAo_Ju on 2019/4/2.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class CustomNav: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}
