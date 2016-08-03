//
//  Copyright © 2016年 NY. All rights reserved.
//

// SO: http://stackoverflow.com/questions/1214965/setting-action-for-back-button-in-navigation-controller/19132881#comment34452906_19132881
public protocol BackBarButtonItemDelegate {
    func viewControllerShouldPopOnBackBarButtonItem() -> Bool
}

extension UINavigationController {
    public func navigationBar(navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        if viewControllers.count < navigationBar.items?.count {
            return true
        }
        var shouldPop = true
        if let viewController = topViewController as? BackBarButtonItemDelegate {
            shouldPop = viewController.viewControllerShouldPopOnBackBarButtonItem()
        }
        if shouldPop {
            dispatch_async(dispatch_get_main_queue()) {
                self.popViewControllerAnimated(true)
            }
        } else {
            // Prevent the back button from staying in an disabled state
            for view in navigationBar.subviews {
                if view.alpha < 1.0 {
                    UIView.animateWithDuration(0.25, animations: { () in
                        view.alpha = 1.0
                    })
                }
            }
        }
        return false
    }
}
