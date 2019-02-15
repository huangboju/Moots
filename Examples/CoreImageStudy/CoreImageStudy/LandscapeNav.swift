//
//  LandscapeNav.swift
//  CoreImageStudy
//
//  Created by xiAo_Ju on 2019/2/15.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class LandscapeNav: UINavigationController {

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
}
