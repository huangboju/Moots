/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The AssetTransitionDriver class manages the transition from start to finish. This object will live the lifetime of the transition, and 
                is resposible for driving the interactivity and animation. It utilizes UIViewPropertyAnimator to smoothly interact and interrupt the 
                transition.
*/

import UIKit


class AssetTransitionDriver: NSObject {

    var transitionAnimator: UIViewPropertyAnimator!
    var isInteractive: Bool { return transitionContext.isInteractive }
    let transitionContext: UIViewControllerContextTransitioning
    
    private let operation: UINavigationController.Operation
    private let panGestureRecognizer: UIPanGestureRecognizer
    private var itemFrameAnimator: UIViewPropertyAnimator?
    private var items: Array<AssetTransitionItem> = []
    private var interactiveItem: AssetTransitionItem?
    
    // MARK: Initialization
    
    init(operation: UINavigationController.Operation, context: UIViewControllerContextTransitioning, panGestureRecognizer panGesture: UIPanGestureRecognizer) {
        self.transitionContext = context
        self.operation = operation
        self.panGestureRecognizer = panGesture
        
        super.init()
        
        
        // Setup the transition "chrome"
        let fromViewController = context.viewController(forKey: .from)!
        let toViewController = context.viewController(forKey: .to)!
        let fromAssetTransitioning = (fromViewController as! AssetTransitioning)
        let toAssetTransitioning = (toViewController as! AssetTransitioning)
        let fromView = fromViewController.view!
        let toView = toViewController.view!
        let containerView = context.containerView
        
        // Add ourselves as a target of the pan gesture
        self.panGestureRecognizer.addTarget(self, action: #selector(updateInteraction))
        
        // Ensure the toView has the correct size and position
        toView.frame = context.finalFrame(for: toViewController)
        
        // Create a visual effect view and animate the effect in the transition animator
        let effect: UIVisualEffect? = (operation == .pop) ? UIBlurEffect(style: .extraLight) : nil
        let targetEffect: UIVisualEffect? = (operation == .pop) ? nil : UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: effect)
        visualEffectView.frame = containerView.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        containerView.addSubview(visualEffectView)
        
        // Insert the toViewController's view into the transition container view
        let topView: UIView
        var topViewTargetAlpha: CGFloat = 0.0
        if operation == .push {
            topView = toView
            topViewTargetAlpha = 1.0
            toView.alpha = 0.0
            containerView.addSubview(toView)
        } else {
            topView = fromView
            topViewTargetAlpha = 0.0
            containerView.insertSubview(toView, at: 0)
        }
        
        // Initiate the handshake between view controller, per the AssetTransitioning Protocol
        self.items = fromAssetTransitioning.itemsForTransition(context: context).filter({ (item) -> Bool in
            guard let targetFrame = toAssetTransitioning.targetFrame(transitionItem: item), !targetFrame.isEmpty && !targetFrame.isNull && !targetFrame.isInfinite else {
                return false
            }
            
            item.targetFrame = containerView.convert(targetFrame, from: toView)
            item.imageView = {
                let imageView = UIImageView(frame: containerView.convert(item.initialFrame, from: nil))
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill
                imageView.isUserInteractionEnabled = true
                imageView.image = item.image
                
                let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(press(_ :)))
                longPressGestureRecognizer.minimumPressDuration = 0.0
                imageView.addGestureRecognizer(longPressGestureRecognizer)
                
                containerView.addSubview(imageView)
                return imageView
            }()
            
            return true
        })
        
        // Inform the view controller's the transition is about to start
        fromAssetTransitioning.willTransition(fromController: fromViewController, toController: toViewController, items: items)
        toAssetTransitioning.willTransition(fromController: fromViewController, toController: toViewController, items: items)
        
        // Add animations and completion to the transition animator
        self.setupTransitionAnimator({
            topView.alpha = topViewTargetAlpha
            visualEffectView.effect = targetEffect
        }, transitionCompletion: { [unowned self] (position) in
            // Finish the protocol handshake
            fromAssetTransitioning.didTransition(fromController: fromViewController, toController: toViewController, items: self.items)
            toAssetTransitioning.didTransition(fromController: fromViewController, toController: toViewController, items: self.items)
            
            // Remove all transition views
            for item in self.items {
                item.imageView?.removeFromSuperview()
            }
            visualEffectView.removeFromSuperview()
        })
        
        if context.isInteractive {
            // If the transition is initially interactive, ensure we know what item is being manipulated
            self.updateInteractiveItemFor(panGestureRecognizer.location(in: containerView))
        } else {
            // Begin the animation phase immediately if the transition is not initially interactive
            animate(.end)
        }
    }
    
    // MARK: Private Helpers
    
    private func updateInteractiveItemFor(_ locationInContainer: CGPoint) {
        
        func itemAtPoint(point: CGPoint) -> AssetTransitionItem? {
            if let view = transitionContext.containerView.hitTest(point, with: nil) {
                for item in self.items {
                    if item.imageView == view {
                        return item
                    }
                }
            }
            return nil
        }
        
        if let item = itemAtPoint(point: locationInContainer), let itemCenter = item.imageView?.center {
            item.touchOffset = locationInContainer - itemCenter
            interactiveItem = item
        }
    }

    private func convert(_ velocity: CGPoint, for item: AssetTransitionItem?) -> CGVector {
        guard let currentFrame = item?.imageView?.frame, let targetFrame = item?.targetFrame else {
            return CGVector.zero
        }
        
        let dx = abs(targetFrame.midX - currentFrame.midX)
        let dy = abs(targetFrame.midY - currentFrame.midY)
        
        guard dx > 0.0 && dy > 0.0 else {
            return CGVector.zero
        }
        
        let range = CGFloat(35.0)
        let clippedVx = clip(-range, range, velocity.x / dx)
        let clippedVy = clip(-range, range, velocity.y / dy)
        return CGVector(dx: clippedVx, dy: clippedVy)
    }
    
    private func timingCurveVelocity() -> CGVector {
        // Convert the gesture recognizer's velocity into the initial velocity for the animation curve
        let gestureVelocity = panGestureRecognizer.velocity(in: transitionContext.containerView)
        return convert(gestureVelocity, for: interactiveItem)
    }
    
    private func completionPosition() -> UIViewAnimatingPosition {
        let completionThreshold: CGFloat = 0.33
        let flickMagnitude: CGFloat = 1200 //pts/sec
        let velocity = panGestureRecognizer.velocity(in: transitionContext.containerView).vector
        let isFlick = (velocity.magnitude > flickMagnitude)
        let isFlickDown = isFlick && (velocity.dy > 0.0)
        let isFlickUp = isFlick && (velocity.dy < 0.0)
        
        if (operation == .push && isFlickUp) || (operation == .pop && isFlickDown) {
            return .end
        } else if (operation == .push && isFlickDown) || (operation == .pop && isFlickUp) {
            return .start
        } else if transitionAnimator.fractionComplete > completionThreshold {
            return .end
        } else {
            return .start
        }
    }
    
    private func updateItemsForInteractive(translation: CGPoint) {
        let progressStep = progressStepFor(translation: translation)
        for item in items {
            let initialSize = item.initialFrame.size
            if let imageView = item.imageView, let finalSize = item.targetFrame?.size {
                let currentSize = imageView.frame.size
                
                let itemPercentComplete = clip(-0.05, 1.05, (currentSize.width - initialSize.width) / (finalSize.width - initialSize.width) + progressStep)
                let itemWidth = lerp(initialSize.width, finalSize.width, itemPercentComplete)
                let itemHeight = lerp(initialSize.height, finalSize.height, itemPercentComplete)
                let scaleTransform = CGAffineTransform(scaleX: (itemWidth / currentSize.width), y: (itemHeight / currentSize.height))
                let scaledOffset = item.touchOffset.apply(transform: scaleTransform)
                
                imageView.center = (imageView.center + (translation + (item.touchOffset - scaledOffset))).point
                imageView.bounds = CGRect(origin: .zero, size: CGSize(width: itemWidth, height: itemHeight))
                item.touchOffset = scaledOffset
            }
        }
    }
    
    private func progressStepFor(translation: CGPoint) -> CGFloat {
        return (operation == .push ? -1.0 : 1.0) * translation.y / transitionContext.containerView.bounds.midY
    }
    
    // MARK: Gesture Callbacks
    
    @objc func press(_ longPressGesture: UILongPressGestureRecognizer) {
        switch longPressGesture.state {
        case .began:
            pauseAnimation()
            updateInteractiveItemFor(longPressGesture.location(in: transitionContext.containerView))
        case .ended, .cancelled:
            endInteraction()
        default: break
        }
    }
    
    // MARK: Interesting UIViewPropertyAnimator Setup
    
    /// UIKit calls startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning)
    /// on our interaction controller (AssetTransitionController). The AssetTransitionDriver (self) is
    /// then created with the transitionContext to manage the transition. It calls this func from Init().
    func setupTransitionAnimator(_ transitionAnimations: @escaping ()->(), transitionCompletion: @escaping (UIViewAnimatingPosition)->()) {
        
        // The duration of the transition, if uninterrupted
        let transitionDuration = AssetTransitionDriver.animationDuration()
        
        // Create a UIViewPropertyAnimator that lives the lifetime of the transition
        transitionAnimator = UIViewPropertyAnimator(duration: transitionDuration, curve: .easeOut, animations: transitionAnimations)
        
        transitionAnimator.addCompletion { [unowned self] (position) in
            // Call the supplied completion
            transitionCompletion(position)
            
            // Inform the transition context that the transition has completed
            let completed = (position == .end)
            self.transitionContext.completeTransition(completed)
        }
    }
    
    // MARK: Interesting Interruptible Transitioning Stuff
    
    @objc func updateInteraction(_ fromGesture: UIPanGestureRecognizer) {
        switch fromGesture.state {
            case .began, .changed:
                // Ask the gesture recognizer for it's translation
                let translation = fromGesture.translation(in: transitionContext.containerView)
                
                // Calculate the percent complete
                let percentComplete = transitionAnimator.fractionComplete + progressStepFor(translation: translation)
                
                // Update the transition animator's fractionCompete to scrub it's animations
                transitionAnimator.fractionComplete = percentComplete
                
                // Inform the transition context of the updated percent complete
                transitionContext.updateInteractiveTransition(percentComplete)
                
                // Update each transition item for the
                updateItemsForInteractive(translation: translation)
                
                // Reset the gestures translation
                fromGesture.setTranslation(CGPoint.zero, in: transitionContext.containerView)
            case .ended, .cancelled:
                // End the interactive phase of the transition
                endInteraction()
            default: break
        }
    }
    
    func endInteraction() {
        // Ensure the context is currently interactive
        guard transitionContext.isInteractive else { return }
        
        // Inform the transition context of whether we are finishing or cancelling the transition
        let completionPosition = self.completionPosition()
        if completionPosition == .end {
            transitionContext.finishInteractiveTransition()
        } else {
            transitionContext.cancelInteractiveTransition()
        }
        
        // Begin the animation phase of the transition to either the start or finsh position
        animate(completionPosition)
    }
    
    func animate(_ toPosition: UIViewAnimatingPosition) {
        // Create a property animator to animate each image's frame change
        let itemFrameAnimator = AssetTransitionDriver.propertyAnimator(initialVelocity: timingCurveVelocity())
        itemFrameAnimator.addAnimations {
            for item in self.items {
                item.imageView?.frame = (toPosition == .end ? item.targetFrame : item.initialFrame)!
            }
        }
        
        // Start the property animator and keep track of it
        itemFrameAnimator.startAnimation()
        self.itemFrameAnimator = itemFrameAnimator
        
        // Reverse the transition animator if we are returning to the start position
        transitionAnimator.isReversed = (toPosition == .start)
        
        // Start or continue the transition animator (if it was previously paused)
        if transitionAnimator.state == .inactive {
            transitionAnimator.startAnimation()
        } else {
            // Calculate the duration factor for which to continue the animation.
            // This has been chosen to match the duration of the property animator created above
            let durationFactor = CGFloat(itemFrameAnimator.duration / transitionAnimator.duration)
            transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: durationFactor)
        }
    }
    
    func pauseAnimation() {
        // Stop (without finishing) the property animator used for transition item frame changes
        itemFrameAnimator?.stopAnimation(true)
        
        // Pause the transition animator
        transitionAnimator.pauseAnimation()
        
        // Inform the transition context that we have paused
        transitionContext.pauseInteractiveTransition()
    }
    
    // MARK: Interesting Property Animator Stuff
    
    class func animationDuration() -> TimeInterval {
        return AssetTransitionDriver.propertyAnimator().duration
    }
    
    class func propertyAnimator(initialVelocity: CGVector = .zero) -> UIViewPropertyAnimator {
        let timingParameters = UISpringTimingParameters(mass: 4.5, stiffness: 1300, damping: 95, initialVelocity: initialVelocity)
        return UIViewPropertyAnimator(duration: assetTransitionDuration, timingParameters:timingParameters)
    }
}
