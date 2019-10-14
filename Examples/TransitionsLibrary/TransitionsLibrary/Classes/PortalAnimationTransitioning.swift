//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class PortalAnimationTransitioning: ReversibleAnimationTransitioning {
    override func animateTransition(_ context: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController, fromView: UIView, toView: UIView) {
        if reverse {
            executeReverseAnimation(context, fromVC: fromVC, toVC: toVC, fromView: fromView, toView: toView)
        } else {
            executeForwardsAnimation(context, fromVC: fromVC, toVC: toVC, fromView: fromView, toView: toView)
        }
    }
    
    let ZOOM_SCALE: CGFloat = 0.8
    func executeForwardsAnimation(_ context: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController, fromView: UIView, toView: UIView) {
        let containerView = context.containerView
        
        let toViewSnapshot = toView.resizableSnapshotView(from: toView.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        let scale = CATransform3DIdentity
        toViewSnapshot!.layer.transform = CATransform3DScale(scale, ZOOM_SCALE, ZOOM_SCALE, 1)
        containerView.addSubview(toViewSnapshot!)
        containerView.sendSubviewToBack(toViewSnapshot!)
        
        let leftSnapshotRegion = CGRect(x: 0, y: 0, width: fromView.frame.width / 2, height: fromView.frame.height)
        let leftHandView = fromView.resizableSnapshotView(from: leftSnapshotRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
        leftHandView!.frame = leftSnapshotRegion
        containerView.addSubview(leftHandView!)
        let rightSnapshotRegion = CGRect(x: fromView.frame.width / 2, y: 0, width: fromView.frame.width / 2, height: fromView.frame.height)
        let rightHandView = fromView.resizableSnapshotView(from: rightSnapshotRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
        rightHandView!.frame = rightSnapshotRegion
        containerView.addSubview(rightHandView!)
        fromView.removeFromSuperview()
        let duration = transitionDuration(using: context)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            let leftOffset = CGRect.offsetBy(leftHandView!.frame)
            leftHandView!.frame = leftOffset(-leftHandView!.frame.width, 0)
            
            let rightOffset = CGRect.offsetBy(rightHandView!.frame)
            rightHandView!.frame = rightOffset(rightHandView!.frame.width, 0)
            
            toViewSnapshot!.center = toView.center
            toViewSnapshot!.frame = toView.frame
            }) { (flag) in
                if context.transitionWasCancelled {
                    containerView.addSubview(fromView)
                    removeOtherViews(fromView)
                } else {
                    containerView.addSubview(toView)
                    removeOtherViews(toView)
                }
                context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
    func executeReverseAnimation(_ context: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController, fromView: UIView, toView: UIView) {
        let containerView = context.containerView
        containerView.addSubview(fromView)
        toView.frame = context.finalFrame(for: toVC)
        let offset = CGRect.offsetBy(toView.frame)
        toView.frame = offset(toView.frame.width, 0)
        containerView.addSubview(toView)
        
        let leftSnapshotRegion = CGRect(x: 0, y: 0, width: toView.frame.width / 2, height: toView.frame.height)
        let leftHandView = toView.resizableSnapshotView(from: leftSnapshotRegion, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        leftHandView!.frame = leftSnapshotRegion
        
        let leftOffset = CGRect.offsetBy(leftHandView!.frame)
        leftHandView!.frame = leftOffset(-leftHandView!.frame.width, 0)
        containerView.addSubview(leftHandView!)
        
        let rightSnapshotRegion = CGRect(x: toView.frame.width / 2, y: 0, width: toView.frame.width / 2, height: toView.frame.height)
        let rightHandView = toView.resizableSnapshotView(from: rightSnapshotRegion, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        rightHandView!.frame = rightSnapshotRegion
       
        let rightOffset = CGRect.offsetBy(rightHandView!.frame)
        rightHandView!.frame = rightOffset(rightHandView!.frame.width, 0)
        containerView.addSubview(rightHandView!)
        
        let duration = transitionDuration(using: context)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            leftHandView!.frame = leftOffset(leftHandView!.frame.width, 0)
            rightHandView!.frame = rightOffset(-rightHandView!.frame.width, 0)
            let scale = CATransform3DIdentity
            fromView.layer.transform = CATransform3DScale(scale, self.ZOOM_SCALE, self.ZOOM_SCALE, 1)
            }) { (flag) in
                if context.transitionWasCancelled {
                    removeOtherViews(fromView)
                } else {
                    removeOtherViews(toView)
                    toView.frame = (containerView.bounds)
                }
                context.completeTransition(!context.transitionWasCancelled)
        }
    }
}

func removeOtherViews(_ viewToKeep: UIView) {
    if let containerView = viewToKeep.superview {
        for view in containerView.subviews {
            if view != viewToKeep    {
                view.removeFromSuperview()
            }
        }
    }
}
