//
//  CustomPresentationController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/13.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    private var dimmingView: UIView?
    
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
        // that applies a shadow and rounded corners to the top-left and top-right
        // edges.  The final effect is built using three intermediate views.
        //
        // presentationWrapperView              <- shadow
        //   |- presentationRoundedCornerView   <- rounded corners (masksToBounds)
        //        |- presentedViewControllerWrapperView
        //             |- presentedViewControllerView (presentedViewController.view)
        //
        // SEE ALSO: The note in AAPLCustomPresentationSecondViewController.m.
        do {

            // presentationRoundedCornerView is CORNER_RADIUS points taller than the
            // height of the presented view controller's view.  This is because
            // the cornerRadius is applied to all corners of the view.  Since the
            // effect calls for only the top two corners to be rounded we size
            // the view such that the bottom CORNER_RADIUS points lie below
            // the bottom edge of the screen.
            
            let presentationWrapperView = UIView(frame: frameOfPresentedViewInContainerView)
            presentationWrapperView.layer.shadowOpacity = 0.44
            presentationWrapperView.layer.shadowRadius = 13
            presentationWrapperView.layer.shadowOffset = CGSize(width: 0, height: -6)
            presentationWrappingView = presentationWrapperView
            
            let presentationRoundedCornerView = UIView(frame: presentationWrapperView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -16, right: 0)))
            presentationRoundedCornerView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            presentationRoundedCornerView.layer.cornerRadius = 16
            presentationRoundedCornerView.layer.masksToBounds = true
            
            // To undo the extra height added to presentationRoundedCornerView,
            // presentedViewControllerWrapperView is inset by CORNER_RADIUS points.
            // This also matches the size of presentedViewControllerWrapperView's
            // bounds to the size of -frameOfPresentedViewInContainerView.

            let presentedViewControllerWrapperView = UIView(frame: presentationRoundedCornerView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)))
            presentedViewControllerWrapperView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            
            // Add presentedViewControllerView -> presentedViewControllerWrapperView.
            presentedViewControllerView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            presentedViewControllerView?.frame = presentedViewControllerWrapperView.bounds
            presentedViewControllerWrapperView.addSubview(presentedViewControllerView!)
            
            // Add presentedViewControllerWrapperView -> presentationRoundedCornerView.
            presentationRoundedCornerView.addSubview(presentedViewControllerWrapperView)
            
            // Add presentationRoundedCornerView -> presentationWrapperView.
            presentationWrapperView.addSubview(presentationRoundedCornerView)
        }
        
        // Add a dimming view behind presentationWrapperView.  self.presentedView
        // is added later (by the animator) so any views added here will be
        // appear behind the -presentedView.
        do {
            
            let dimmingView = UIView(frame: containerView!.bounds)
            dimmingView.backgroundColor = UIColor.black
            dimmingView.isOpaque = false
            dimmingView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped)))
            self.dimmingView = dimmingView
            containerView?.addSubview(dimmingView)
            
            // Get the transition coordinator for the presentation so we can
            // fade in the dimmingView alongside the presentation animation.
            let transitionCoordinator = presentingViewController.transitionCoordinator
            
            dimmingView.alpha = 0
            transitionCoordinator?.animate(alongsideTransition: { context in
                dimmingView.alpha = 0.5
            }, completion: nil)
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        // The value of the 'completed' argument is the same value passed to the
        // -completeTransition: method by the animator.  It may
        // be NO in the case of a cancelled interactive transition.
        if !completed {
            // The system removes the presented view controller's view from its
            // superview and disposes of the containerView.  This implicitly
            // removes the views created in -presentationTransitionWillBegin: from
            // the view hierarchy.  However, we still need to relinquish our strong
            // references to those view.
            presentationWrappingView = nil
            dimmingView = nil
        }
    }
    
    override func dismissalTransitionWillBegin() {
        // Get the transition coordinator for the presentation so we can
        // fade in the dimmingView alongside the presentation animation.
        let transitionCoordinator = presentingViewController.transitionCoordinator

        transitionCoordinator?.animate(alongsideTransition: { context in
            self.dimmingView?.alpha = 0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        // The value of the 'completed' argument is the same value passed to the
        // -completeTransition: method by the animator.  It may
        // be NO in the case of a cancelled interactive transition.
        if completed {
            // The system removes the presented view controller's view from its
            // superview and disposes of the containerView.  This implicitly
            // removes the views created in -presentationTransitionWillBegin: from
            // the view hierarchy.  However, we still need to relinquish our strong
            // references to those view.
            presentationWrappingView = nil
            dimmingView = nil
        }
    }
    
    //| ----------------------------------------------------------------------------
    //  This method is invoked whenever the presentedViewController's
    //  preferredContentSize property changes.  It is also invoked just before the
    //  presentation transition begins (prior to -presentationTransitionWillBegin).
    //
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)

        if container === presentedViewController {
            containerView?.setNeedsLayout()
        }
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
            return (container as? UIViewController)!.preferredContentSize
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerViewBounds = containerView?.bounds ?? .zero
        let presentedViewContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerViewBounds.size)
        
        // The presented view extends presentedViewContentSize.height points from
        // the bottom edge of the screen.
        var presentedViewControllerFrame = containerViewBounds
        presentedViewControllerFrame.size.height = presentedViewContentSize.height
        presentedViewControllerFrame.origin.y = containerViewBounds.maxY - presentedViewContentSize.height
        return presentedViewControllerFrame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        dimmingView?.frame = containerView?.bounds ?? .zero
        presentationWrappingView?.frame = frameOfPresentedViewInContainerView
    }
    
    @objc
    func dimmingViewTapped() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}

extension CustomPresentationController: UIViewControllerAnimatedTransitioning {
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
        // If NO is returned from -shouldRemovePresentersView, the view associated
        // with UITransitionContextFromViewKey is nil during presentation.  This
        // intended to be a hint that your animator should NOT be manipulating the
        // presenting view controller's view.  For a dismissal, the -presentedView
        // is returned.
        //
        // Why not allow the animator manipulate the presenting view controller's
        // view at all times?  First of all, if the presenting view controller's
        // view is going to stay visible after the animation finishes during the
        // whole presentation life cycle there is no need to animate it at all — it
        // just stays where it is.  Second, if the ownership for that view
        // controller is transferred to the presentation controller, the
        // presentation controller will most likely not know how to layout that
        // view controller's view when needed, for example when the orientation
        // changes, but the original owner of the presenting view controller does.
        let fromView = transitionContext.view(forKey: .from)
        
        let isPresenting = (fromVC == self.presentingViewController)
        
        // This will be the current frame of fromViewController.view.
        
        _ = transitionContext.initialFrame(for: fromVC)
        // For a presentation which removes the presenter's view, this will be
        // CGRectZero.  Otherwise, the current frame of fromViewController.view.
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
        // This will be CGRectZero.
        var toViewInitialFrame = transitionContext.initialFrame(for: toVC)
        // For a presentation, this will be the value returned from the
        // presentation controller's -frameOfPresentedViewInContainerView method.
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)
        
        // We are responsible for adding the incoming view to the containerView
        // for the presentation (will have no effect on dismissal because the
        // presenting view controller's view was not removed).
        if let toView = toView {        
            containerView.addSubview(toView)
        }
        
        if isPresenting {
            toViewInitialFrame.origin = CGPoint(x: containerView.bounds.minX, y: containerView.bounds.maxY)
            toViewInitialFrame.size = toViewFinalFrame.size
            toView?.frame = toViewInitialFrame
        } else {
            // Because our presentation wraps the presented view controller's view
            // in an intermediate view hierarchy, it is more accurate to rely
            // on the current frame of fromView than fromViewInitialFrame as the
            // initial frame (though in this example they will be the same).
            fromViewFinalFrame = fromView?.frame.offsetBy(dx: 0, dy: fromView?.frame.height ?? 0) ?? .zero
        }

        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, animations: {
            if isPresenting {
                toView?.frame = toViewFinalFrame
            } else {
                fromView?.frame = fromViewFinalFrame
            }
        }, completion: { finished in
            // When we complete, tell the transition context
            // passing along the BOOL that indicates whether the transition
            // finished or not.
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        })
    }
}

extension CustomPresentationController: UIViewControllerTransitioningDelegate {
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

