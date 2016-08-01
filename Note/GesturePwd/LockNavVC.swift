//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class LockNavVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.systemFontOfSize(19)]
        
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        navigationBar.shadowImage = UIImage()
        
        navigationBar.tintColor = UIColor.redColor()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
