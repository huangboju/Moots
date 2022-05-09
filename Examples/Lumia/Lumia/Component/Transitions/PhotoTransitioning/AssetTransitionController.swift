/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The AssetTransitionController class conforms to UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning and UIViewControllerInteractiveTransitioning. 
                This class also manages the gesture recognizer used to initiate the custom interactive pop transition.
*/

import UIKit

let assetTransitionDuration = 0.8

class AssetTransitionController: NSObject {
    
    weak var navigationController: UINavigationController?
    var operation: UINavigationController.Operation = .none
    var transitionDriver: AssetTransitionDriver?
    var initiallyInteractive = false
    var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    init(navigationController nc: UINavigationController) {
        navigationController = nc
        super.init()

        nc.delegate = self
        configurePanGestureRecognizer()
    }
    
    func configurePanGestureRecognizer() {
        panGestureRecognizer.delegate = self
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.addTarget(self, action: #selector(initiateTransitionInteractively(_:)))
        navigationController?.view.addGestureRecognizer(panGestureRecognizer)
        
        guard let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer else { return }
        panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
    }
    
    @objc func initiateTransitionInteractively(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began && transitionDriver == nil {
            initiallyInteractive = true
            let _ = navigationController?.popViewController(animated: true)
        }
    }
}

extension AssetTransitionController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let transitionDriver = self.transitionDriver else {
            let translation = panGestureRecognizer.translation(in: panGestureRecognizer.view)
            let translationIsVertical = (translation.y > 0) && (abs(translation.y) > abs(translation.x))
            return translationIsVertical && (navigationController?.viewControllers.count ?? 0 > 1)
        }
        
        return transitionDriver.isInteractive
    }
}

extension AssetTransitionController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // Remember the direction of the transition (.push or .pop)
        self.operation = operation
        
        // Return ourselves as the animation controller for the pending transition
        return self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        // Return ourselves as the interaction controller for the pending transition
        return self
    }
}

extension AssetTransitionController: UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        // Create our helper object to manage the transition for the given transitionContext.
        transitionDriver = AssetTransitionDriver(operation: operation, context: transitionContext, panGestureRecognizer: panGestureRecognizer)
    }
    
    var wantsInteractiveStart: Bool {
        
        // Determines whether the transition begins in an interactive state
        return initiallyInteractive
    }
}

extension AssetTransitionController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return assetTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {}
    
    func animationEnded(_ transitionCompleted: Bool) {
        // Clean up our helper object and any additional state
        transitionDriver = nil
        initiallyInteractive = false
        operation = .none
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        // The transition driver (helper object), creates the UIViewPropertyAnimator (transitionAnimator) 
        // to be used for this transition. It must live the lifetime of the transitionContext.
        return (transitionDriver?.transitionAnimator)!
    }
}
