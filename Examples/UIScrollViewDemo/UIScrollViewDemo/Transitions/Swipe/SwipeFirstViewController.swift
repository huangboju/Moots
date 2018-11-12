//
//  SwipeFirstViewController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/12.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class SwipeFirstViewController: UIViewController {
    
    private lazy var customTransitionDelegate: SwipeTransitionDelegate = {
        let delegate = SwipeTransitionDelegate()
        return delegate
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let interactiveTransitionRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(interactiveTransitionRecognizerAction))
        interactiveTransitionRecognizer.edges = .right
        view.addGestureRecognizer(interactiveTransitionRecognizer)
    }
    
    @objc
    func interactiveTransitionRecognizerAction(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began {
            let destinationViewController = SwipeSecondViewController()
            
            // Unlike in the Cross Dissolve demo, we use a separate object as the
            // transition delegate rather then (our)self.  This promotes
            // 'separation of concerns' as AAPLSwipeTransitionDelegate will
            // handle pairing the correct animation controller and interaction
            // controller for the presentation.
            
            // If this will be an interactive presentation, pass the gesture
            // recognizer along to our AAPLSwipeTransitionDelegate instance
            // so it can return the necessary
            // <UIViewControllerInteractiveTransitioning> for the presentation.
            let transitionDelegate = customTransitionDelegate
            customTransitionDelegate.gestureRecognizer = sender
            
            // Set the edge of the screen to present the incoming view controller
            // from.  This will match the edge we configured the
            // UIScreenEdgePanGestureRecognizer with previously.
            //
            // NOTE: We can not retrieve the value of our gesture recognizer's
            //       configured edges because prior to iOS 8.3
            //       UIScreenEdgePanGestureRecognizer would always return
            //       UIRectEdgeNone when querying its edges property.
            transitionDelegate.targetEdge = .right
            
            // Note that the view controller does not hold a strong reference to
            // its transitioningDelegate.  If you instantiate a separate object
            // to be the transitioningDelegate, ensure that you hold a strong
            // reference to that object.
            destinationViewController.transitioningDelegate = transitionDelegate
            
            // Setting the modalPresentationStyle to FullScreen enables the
            // <ContextTransitioning> to provide more accurate initial and final
            // frames of the participating view controllers.
            destinationViewController.modalPresentationStyle = .fullScreen
            
            present(destinationViewController, animated: true, completion: nil)
        }
    }
}
