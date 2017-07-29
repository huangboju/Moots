//
//  ExpandAnimator.swift
//  TransitionsLibrary
//
//  Created by 黄伯驹 on 2017/7/15.
//  Copyright © 2017年 xiAo_Ju. All rights reserved.
//

class ExpandAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    static var animator = ExpandAnimator()
    
    enum ExpandTransitionMode {
        case present, dismiss
    }
    
    let presentDuration = 0.4
    let dismissDuration = 0.15
    
    var openingFrame = CGRect.zero
    var transitionMode: ExpandTransitionMode = .present
    
    var topView: UIView!
    var bottomView: UIView!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionMode == .present ? presentDuration : dismissDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let topVC = transitionContext.viewController(forKey: .to) else { return }

        let fromViewFrame = fromVC.view.frame
        
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            topView = fromVC.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets(top: openingFrame.minY, left: 0, bottom: 0, right: 0))
            topView.frame = CGRect(x: 0, y: 0, width: fromViewFrame.width, height: openingFrame.minY)
            
            containerView.addSubview(topView)
            
            bottomView = fromVC.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: fromViewFrame.width - openingFrame.minY - openingFrame.height, right: 0))
            bottomView.frame = CGRect(x: 0, y: openingFrame.maxY, width: fromViewFrame.width, height: fromViewFrame.height - openingFrame.maxY)

            containerView.addSubview(bottomView)
            
            let snapshotView = topVC.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: .zero)
            snapshotView?.frame = openingFrame
            
            containerView.addSubview(snapshotView!)
            
            topVC.view.alpha = 0
            containerView.addSubview(topVC.view)
            
            UIView.animate(withDuration: presentDuration, animations: {

                self.topView.frame = CGRect(x: 0, y: -self.topView.frame.height, width: -self.topView.frame.width, height: -self.topView.frame.height)
                self.bottomView.frame = CGRect(x: 0, y: fromViewFrame.height, width: self.bottomView.frame.width, height: self.bottomView.frame.height)

                snapshotView?.frame = topVC.view.frame
                
            }, completion: { flag in
                snapshotView?.removeFromSuperview()

                topVC.view.alpha = 1
                transitionContext.completeTransition(true)
            
            })
            
        } else {
            let snapshotView = topVC.view.resizableSnapshotView(from: fromVC.view.bounds, afterScreenUpdates: true, withCapInsets: .zero)
            containerView.addSubview(snapshotView!)
            
            fromVC.view.alpha = 0
            
            UIView.animate(withDuration: dismissDuration, delay: 0, options: .curveEaseIn, animations: { 
                self.topView.frame = CGRect(x: 0, y: 0, width: self.topView.frame.width, height: self.topView.frame.height)
                self.bottomView.frame = CGRect(x: 0, y: fromVC.view.frame.height - self.bottomView.frame.height, width: self.bottomView.frame.width, height: self.bottomView.frame.height)

                snapshotView?.frame = self.openingFrame
            }, completion: { flag in
                snapshotView?.removeFromSuperview()
    
                fromVC.view.alpha = 1
                transitionContext.completeTransition(true)
            })
        }
        
    }
}
