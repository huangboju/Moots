//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class SDEModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var animatedTransitioning: UIViewControllerAnimatedTransitioning {
        switch ADConfig.shared.transitionType {
        case .overlayVertical, .overlayHorizontal:
            return OverlayAnimationController()
        case .bottomToTop, .topToBottom, .leftToRight, .rightToLeft:
            return SliderAnimationController()
        }
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedTransitioning
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedTransitioning
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
