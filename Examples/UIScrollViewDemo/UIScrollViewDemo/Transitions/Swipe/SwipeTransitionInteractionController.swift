//
//  SwipeTransitionInteractionController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/12.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class SwipeTransitionInteractionController: UIPercentDrivenInteractiveTransition {
    var transitionContext: UIViewControllerContextTransitioning?
    var gestureRecognizer: UIScreenEdgePanGestureRecognizer?
    var edge: UIRectEdge = []
    
    deinit {
        gestureRecognizer?.removeTarget(self, action: #selector(gestureRecognizeDidUpdate))
    }

    init(gestureRecognizer: UIScreenEdgePanGestureRecognizer, edgeForDragging edge: UIRectEdge) {
        super.init()
        self.gestureRecognizer = gestureRecognizer
        self.edge = edge
        gestureRecognizer.addTarget(self, action: #selector(gestureRecognizeDidUpdate))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // Save the transitionContext for later.
        self.transitionContext = transitionContext

        super.startInteractiveTransition(transitionContext)
    }
    
    //| ----------------------------------------------------------------------------
    //! Returns the offset of the pan gesture recognizer from the edge of the
    //! screen as a percentage of the transition container view's width or height.
    //! This is the percent completed for the interactive transition.
    //
    func percent(for gesture: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        // Because view controllers will be sliding on and off screen as part
        // of the animation, we want to base our calculations in the coordinate
        // space of the view that will not be moving: the containerView of the
        // transition context.
        guard let transitionContainerView = transitionContext?.containerView else { return 0 }

        let locationInSourceView = gesture.location(in: transitionContainerView)
        
        // Figure out what percentage we've gone.
        
        let width = transitionContainerView.bounds.width
        let height = transitionContainerView.bounds.height
        
        // Return an appropriate percentage based on which edge we're dragging
        // from.
        if edge == .right {
            return (width - locationInSourceView.x) / width
        } else if edge == .left {
            return locationInSourceView.x / width
        } else if edge == .bottom {
            return (height - locationInSourceView.y) / height
        } else if edge == .top {
            return locationInSourceView.y / height
        } else {
            return 0
        }
    }
    
    @objc
    func gestureRecognizeDidUpdate(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began: break
            // The Began state is handled by the view controllers.  In response
            // to the gesture recognizer transitioning to this state, they
            // will trigger the presentation or dismissal.
        case .changed:
            // We have been dragging! Update the transition context accordingly.
            update(percent(for: gestureRecognizer))
        case .ended:
            // Dragging has finished.
            // Complete or cancel, depending on how far we've dragged.
            if percent(for: gestureRecognizer) >= 0.5 {
                finish()
            } else {
                cancel()
            }
        default:
            // Something happened. cancel the transition.
            cancel()
        }
    }
}
