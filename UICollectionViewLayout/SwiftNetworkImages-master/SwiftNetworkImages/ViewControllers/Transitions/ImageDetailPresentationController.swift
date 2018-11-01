//
//  ImageDetailPresentationController.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 9/10/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit


class ImageDetailPresentationController: UIPresentationController {
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        dimmerView =  UIView(frame: CGRect.zero)
        dimmerView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        dimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return super.frameOfPresentedViewInContainerView.insetBy(dx: 20.0, dy: 20.0)
    }
    
    override var presentedView: UIView? {
        guard let theView = super.presentedView else { return nil }
        theView.layer.cornerRadius = 6
        theView.layer.masksToBounds = true
        return theView
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView,
              let transitionCoordinator = presentedViewController.transitionCoordinator else { return }
        dimmerView.frame = containerView.bounds
        dimmerView.alpha = 0.0
        containerView.insertSubview(dimmerView, at: 0)
        transitionCoordinator.animate(alongsideTransition: { _ in
            self.dimmerView.alpha = 1.0
        })
    }
    override func presentationTransitionDidEnd(_ completed: Bool)  {
        // If the presentation didn't complete, remove the dimming view
        if !completed {
            dimmerView.removeFromSuperview()
        }
        if let adjustedView = self.presentingViewController.view {
            adjustedView.tintAdjustmentMode = .dimmed
        }
    }
    
    
    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else { return }
        transitionCoordinator.animate(alongsideTransition: { _ in
            self.dimmerView.alpha = 0
        })
    }
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if let adjustedView = self.presentingViewController.view {
            adjustedView.tintAdjustmentMode = .automatic
        }        
    }
    
    fileprivate var dimmerView: UIView
}
