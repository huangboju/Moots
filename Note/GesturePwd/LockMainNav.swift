//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class LockMainNav: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: LockCenter.sharedInstance.options.barTittleColor, NSFontAttributeName: LockCenter.sharedInstance.options.barTittleFont]
        
        if LockCenter.sharedInstance.options.hideBarBottomLine {
            navigationBar.hideBottomHairline()
        }
        
        navigationBar.tintColor = LockCenter.sharedInstance.options.barTintColor
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
