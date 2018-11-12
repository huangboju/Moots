//
//  SwipeSecondViewController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/12.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class SwipeSecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: 0xD6E663)

        let interactiveTransitionRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(interactiveTransitionRecognizerAction))
        interactiveTransitionRecognizer.edges = .left
        view.addGestureRecognizer(interactiveTransitionRecognizer)
    }
    
    @objc
    func interactiveTransitionRecognizerAction(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began {
            // Unlike in the Cross Dissolve demo, we use a separate object as the
            // transition delegate rather then (our)self.  This promotes
            // 'separation of concerns' as AAPLSwipeTransitionDelegate will
            // handle pairing the correct animation controller and interaction
            // controller for the presentation.
            
            // If this will be an interactive presentation, pass the gesture
            // recognizer along to our AAPLSwipeTransitionDelegate instance
            // so it can return the necessary
            // <UIViewControllerInteractiveTransitioning> for the presentation.
            guard let transitionDelegate = transitioningDelegate as? SwipeTransitionDelegate else { return }
            transitionDelegate.gestureRecognizer = sender
            
            // Set the edge of the screen to present the incoming view controller
            // from.  This will match the edge we configured the
            // UIScreenEdgePanGestureRecognizer with previously.
            //
            // NOTE: We can not retrieve the value of our gesture recognizer's
            //       configured edges because prior to iOS 8.3
            //       UIScreenEdgePanGestureRecognizer would always return
            //       UIRectEdgeNone when querying its edges property.
            transitionDelegate.targetEdge = .left
            
            dismiss(animated: true, completion: nil)
        }
    }
}
