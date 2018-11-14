//
//  SlideTransitionDelegate.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/14.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class SlideTransitionDelegate: NSObject {
    static let SlideTabBarControllerDelegateAssociationKey = "SlideTabBarControllerDelegateAssociationKey"
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerDidPan))
        return panGestureRecognizer
    }()
    
    weak var tabBarController: UITabBarController? {
        didSet {
            if oldValue != tabBarController {
                // Remove all associations of this object from the old tab bar
                // controller.
                if let oldValue = oldValue {
                    objc_setAssociatedObject(oldValue, SlideTransitionDelegate.SlideTabBarControllerDelegateAssociationKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
                oldValue?.view.removeGestureRecognizer(panGestureRecognizer)
                if oldValue?.delegate === self {
                    oldValue?.delegate = nil
                }
                
                tabBarController?.delegate = self
                tabBarController?.view.addGestureRecognizer(panGestureRecognizer)
                // Associate this object with the new tab bar controller.  This ensures
                // that this object wil not be deallocated prior to the tab bar
                // controller being deallocated.
                objc_setAssociatedObject(tabBarController!, SlideTransitionDelegate.SlideTabBarControllerDelegateAssociationKey, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    
    @objc
    func panGestureRecognizerDidPan(_ sender: UIPanGestureRecognizer) {
        // Do not attempt to begin an interactive transition if one is already
        // ongoing
        if tabBarController?.transitionCoordinator != nil { return }
        
        if sender.state == .began || sender.state == .changed {
            beginInteractiveTransitionIfPossible(sender)
        }
        
        // Remaining cases are handled by the vended
        // AAPLSlideTransitionInteractionController.
    }
    
    func beginInteractiveTransitionIfPossible(_ sender: UIPanGestureRecognizer) {
        guard let tabBarController = tabBarController else { return }
        let translation = sender.translation(in: tabBarController.view)
        
        if translation.x > 0 && tabBarController.selectedIndex > 0 {
            // Panning right, transition to the left view controller.
            tabBarController.selectedIndex -= 1
        } else if translation.x < 0 && tabBarController.selectedIndex + 1 < (tabBarController.viewControllers?.count ?? 0) {
            // Panning left, transition to the right view controller.
            tabBarController.selectedIndex += 1
        } else {
            // Don't reset the gesture recognizer if we skipped starting the
            // transition because we don't have a translation yet (and thus, could
            // not determine the transition direction).
            if translation != .zero {
                // There is not a view controller to transition to, force the
                // gesture recognizer to fail.
                sender.isEnabled = false
                sender.isEnabled = true
            }
        }
        
        // We must handle the case in which the user begins panning but then
        // reverses direction without lifting their finger.  The transition
        // should seamlessly switch to revealing the correct view controller
        // for the new direction.
        //
        // The approach presented in this demonstration relies on coordination
        // between this object and the AAPLSlideTransitionInteractionController
        // it vends.  If the AAPLSlideTransitionInteractionController detects
        // that the current position of the user's touch along the horizontal
        // axis has crossed over the initial position, it cancels the
        // transition.  A completion block is attached to the tab bar
        // controller's transition coordinator.  This block will be called when
        // the transition completes or is cancelled.  If the transition was
        // cancelled but the gesture recgonzier has not transitioned to the
        // ended or failed state, a new transition to the proper view controller
        // is started, and new animation + interaction controllers are created.
        //
        tabBarController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            
        }, completion: { (context) in
            if context.isCancelled && sender.state == .changed {
                self.beginInteractiveTransitionIfPossible(sender)
            }
        })
    }
}

extension SlideTransitionDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let viewControllers = tabBarController.viewControllers
        let toVCIndex = viewControllers?.firstIndex(of: toVC) ?? 0
        let fromVCIndex = viewControllers?.firstIndex(of: fromVC) ?? 0
        if toVCIndex > fromVCIndex {
            // The incoming view controller succeeds the outgoing view controller,
            // slide towards the left.
            return SlideTransitionAnimator(targetEdge: .left)
        } else {
            // The incoming view controller precedes the outgoing view controller,
            // slide towards the right.
            return SlideTransitionAnimator(targetEdge: .right)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if panGestureRecognizer.state == .began || panGestureRecognizer.state == .changed {
            return SlideTransitionInteractionController(gestureRecognizer: panGestureRecognizer)
        } else {
            // You must not return an interaction controller from this method unless
            // the transition will be interactive.
            return nil
        }
    }
}
