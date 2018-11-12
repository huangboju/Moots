//
//  SwipeTransitionDelegate.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/12.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class SwipeTransitionDelegate: NSObject {
    //! If this transition will be interactive, this property is set to the
    //! gesture recognizer which will drive the interactivity.
    public var gestureRecognizer: UIScreenEdgePanGestureRecognizer?
    public var targetEdge: UIRectEdge = []

}

extension SwipeTransitionDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeTransitionAnimator(targetEdge: targetEdge)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeTransitionAnimator(targetEdge: targetEdge)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let gestureRecognizer = gestureRecognizer else {
            return nil
        }
        return SwipeTransitionInteractionController(gestureRecognizer: gestureRecognizer, edgeForDragging: targetEdge)
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let gestureRecognizer = gestureRecognizer else {
            return nil
        }
        return SwipeTransitionInteractionController(gestureRecognizer: gestureRecognizer, edgeForDragging: targetEdge)
    }
}
