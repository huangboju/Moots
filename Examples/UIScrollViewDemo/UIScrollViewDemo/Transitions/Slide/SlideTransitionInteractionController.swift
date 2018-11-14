//
//  SlideTransitionInteractionController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/14.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class SlideTransitionInteractionController: UIPercentDrivenInteractiveTransition {
    weak var transitionContext: UIViewControllerContextTransitioning?
    var gestureRecognizer: UIPanGestureRecognizer?
    var initialLocationInContainerView: CGPoint = .zero
    var initialTranslationInContainerView: CGPoint = .zero
    
    deinit {
        gestureRecognizer?.removeTarget(self, action: #selector(gestureRecognizeDidUpdate))
    }

    init(gestureRecognizer: UIPanGestureRecognizer) {
        super.init()
        self.gestureRecognizer = gestureRecognizer
        gestureRecognizer.addTarget(self, action: #selector(gestureRecognizeDidUpdate))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // Save the transitionContext, initial location, and the translation within
        // the containing view.
        self.transitionContext = transitionContext
        initialLocationInContainerView = gestureRecognizer?.location(in: transitionContext.containerView) ?? .zero
        initialTranslationInContainerView = gestureRecognizer?.translation(in: transitionContext.containerView) ?? .zero
        
        super.startInteractiveTransition(transitionContext)
    }
    
    //| ----------------------------------------------------------------------------
    //! Returns the offset of the pan gesture recognizer from its initial location
    //! as a percentage of the transition container view's width.  This is
    //! the percent completed for the interactive transition.
    //
    func percent(for gesture: UIPanGestureRecognizer?) -> CGFloat {
        guard let gesture = gesture else { return 0 }
        let transitionContainerView = transitionContext?.containerView

        let translationInContainerView = gesture.translation(in: transitionContainerView)
        
        // If the direction of the current touch along the horizontal axis does not
        // match the initial direction, then the current touch position along
        // the horizontal axis has crossed over the initial position.  See the
        // comment in the -beginInteractiveTransitionIfPossible: method of
        // AAPLSlideTransitionDelegate.
        if (translationInContainerView.x > 0 && initialTranslationInContainerView.x < 0) ||
            (translationInContainerView.x < 0 && initialTranslationInContainerView.x > 0) {
            return -1
        }
        
        // Figure out what percentage we've traveled.
        return abs(translationInContainerView.x) / transitionContainerView!.bounds.width
    }
    
    @objc
    func gestureRecognizeDidUpdate(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            // The Began state is handled by AAPLSlideTransitionDelegate.  In
            // response to the gesture recognizer transitioning to this state,
            // it will trigger the transition.
            break
        case .changed:
            // -percentForGesture returns -1.f if the current position of the
            // touch along the horizontal axis has crossed over the initial
            // position.  See the comment in the
            // -beginInteractiveTransitionIfPossible: method of
            // AAPLSlideTransitionDelegate for details.
            let offset = percent(for: gestureRecognizer)
            if offset < 0 {
                cancel()
                // Need to remove our action from the gesture recognizer to
                // ensure it will not be called again before deallocation.
                gestureRecognizer?.removeTarget(self, action: #selector(gestureRecognizeDidUpdate))
            } else {
                // We have been dragging! Update the transition context
                // accordingly.
                update(offset)
            }
        case .ended:
            // Dragging has finished.
            // Complete or cancel, depending on how far we've dragged.
            if percent(for: gestureRecognizer) >= 0.4 {
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
