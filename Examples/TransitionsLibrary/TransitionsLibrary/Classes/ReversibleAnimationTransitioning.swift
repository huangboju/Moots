//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class ReversibleAnimationTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    var reverse = false
    var duration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        if let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from), let toVC = context.viewController(forKey: UITransitionContextViewControllerKey.to) {
            let toView = toVC.view
            let fromView = fromVC.view
            animateTransition(context, fromVC: fromVC, toVC: toVC, fromView: fromView!, toView: toView!)
        }
    }
    
    func animateTransition(_ context: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController, fromView: UIView, toView: UIView) {
        
    }
}
