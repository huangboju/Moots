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
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.frame.origin.y = UIScreen.main.bounds.height - 400
        view.frame.size.height = 400
    }

}
