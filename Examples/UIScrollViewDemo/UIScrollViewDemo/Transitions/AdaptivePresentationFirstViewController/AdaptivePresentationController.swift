//
//  AdaptivePresentationController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/14.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class AdaptivePresentationController: UIPresentationController {
    private var dismissButton: UIButton?
    
    private var presentationWrappingView: UIView?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }
    
    override var presentedView: UIView? {
        return presentationWrappingView
    }
    
    override func presentationTransitionWillBegin() {
        // The default implementation of -presentedView returns
        // self.presentedViewController.view.
        let presentedViewControllerView = super.presentedView
        
        // Wrap the presented view controller's view in an intermediate hierarchy
        // that applies a shadow and adds a dismiss button to the top left corner.
        //
        // presentationWrapperView              <- shadow
        //     |- presentedViewControllerView (presentedViewController.view)
        //     |- close button
        let presentationWrapperView = UIView(frame: .zero)
        presentationWrapperView.layer.shadowOpacity = 0.63
        presentationWrapperView.layer.shadowRadius = 17
        presentationWrappingView = presentationWrapperView
        
        // Add presentedViewControllerView -> presentationWrapperView.
        presentedViewControllerView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        //presentedViewControllerView.layer.borderColor = [UIColor grayColor].CGColor;
        //presentedViewControllerView.layer.borderWidth = 2.f;
        presentationWrapperView.addSubview(presentedViewControllerView!)
        
        // Create the dismiss button.
        
        let dismissButton = UIButton(type: UIButton.ButtonType.custom)
        
        dismissButton.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        dismissButton.setImage(UIImage(named: "CloseButton"), for: UIControl.State.normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: UIControl.Event.touchUpInside)
        self.dismissButton = dismissButton
        
        // Add dismissButton -> presentationWrapperView.
        presentationWrapperView.addSubview(dismissButton)
    }
    
    
    @objc
    func dismissButtonTapped() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    //| ----------------------------------------------------------------------------
    //  This method is invoked when the interface rotates.  For performance,
    //  the shadow on presentationWrapperView is disabled for the duration
    //  of the rotation animation.
    //
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        presentationWrappingView?.clipsToBounds = true
        presentationWrappingView?.layer.shadowOpacity = 0
        presentationWrappingView?.layer.shadowRadius = 0
        
        coordinator.animate(alongsideTransition: { (context) in
            
        }, completion: { _ in
            // Intentionally left blank.
            self.presentationWrappingView?.clipsToBounds = false
            self.presentationWrappingView?.layer.shadowOpacity = 0.63
            self.presentationWrappingView?.layer.shadowRadius = 17
        })
    }

    //| ----------------------------------------------------------------------------
    //  When the presentation controller receives a
    //  -viewWillTransitionToSize:withTransitionCoordinator: message it calls this
    //  method to retrieve the new size for the presentedViewController's view.
    //  The presentation controller then sends a
    //  -viewWillTransitionToSize:withTransitionCoordinator: message to the
    //  presentedViewController with this size as the first argument.
    //
    //  Note that it is up to the presentation controller to adjust the frame
    //  of the presented view controller's view to match this promised size.
    //  We do this in -containerViewWillLayoutSubviews.
    //
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container === presentedViewController {
            return CGSize(width: parentSize.width / 2, height: parentSize.height / 2)
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerViewBounds = containerView?.bounds ?? .zero
        let presentedViewContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerViewBounds.size)
        
        // The presented view extends presentedViewContentSize.height points from
        // the bottom edge of the screen.
        let rect = CGRect(x: containerViewBounds.midX - presentedViewContentSize.width/2,
                          y: containerViewBounds.midY - presentedViewContentSize.height/2,
                          width: presentedViewContentSize.width,
                          height: presentedViewContentSize.height)
        return rect.insetBy(dx: -20, dy: -20)
    }
    
    //| ----------------------------------------------------------------------------
    //  This method is similar to the -viewWillLayoutSubviews method in
    //  UIViewController.  It allows the presentation controller to alter the
    //  layout of any custom views it manages.
    //
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentationWrappingView?.frame = frameOfPresentedViewInContainerView;
        
        // Undo the outset that was applied in -frameOfPresentedViewInContainerView.
        presentedViewController.view.frame = presentationWrappingView?.bounds.insetBy(dx: 20, dy: 20) ?? .zero
        
        // Position the dismissButton above the top-left corner of the presented
        // view controller's view.
        dismissButton?.center = CGPoint(x: presentedViewController.view.frame.minX,
                                       y: presentedViewController.view.frame.minY)
    }
    
    @objc
    func dimmingViewTapped() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}

extension AdaptivePresentationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated ?? true) ? 0.35 : 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        // For a Presentation:
        //      fromView = The presenting view.
        //      toView   = The presented view.
        // For a Dismissal:
        //      fromView = The presented view.
        //      toView   = The presenting view.
        
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)

        let isPresenting = (fromVC == self.presentingViewController)
        
        // We are responsible for adding the incoming view to the containerView
        // for the presentation (will have no effect on dismissal because the
        // presenting view controller's view was not removed).
        if let toView = toView {
            containerView.addSubview(toView)
        }
        
        if isPresenting {
            toView?.alpha = 0
            
            // This animation only affects the alpha.  The views can be set to
            // their final frames now.
            
            fromView?.frame = transitionContext.finalFrame(for: fromVC)
            toView?.frame = transitionContext.finalFrame(for: toVC)
        } else {
            // Because our presentation wraps the presented view controller's view
            // in an intermediate view hierarchy, it is more accurate to rely
            // on the current frame of fromView than fromViewInitialFrame as the
            // initial frame.
            toView?.frame = transitionContext.finalFrame(for: toVC)
        }
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, animations: {
            if isPresenting {
                toView?.alpha = 1
            } else {
                fromView?.alpha = 0
            }
        }, completion: { finished in
            // When we complete, tell the transition context
            // passing along the BOOL that indicates whether the transition
            // finished or not.
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
            
            // Reset the alpha of the dismissed view, in case it will be used
            // elsewhere in the app.
            if isPresenting {
                fromView?.alpha = 1
            }
        })
    }
}

extension AdaptivePresentationController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
