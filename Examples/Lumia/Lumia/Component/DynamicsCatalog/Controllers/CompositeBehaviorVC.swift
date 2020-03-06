//
//  CompositeBehaviorVC.swift
//  Lumia
//
//  Created by 黄伯驹 on 2020/1/1.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import UIKit

class CompositeBehaviorVC: UIViewController {
    
    private lazy var square: UIImageView = {
        let square = UIImageView(image: UIImage(named: "Box1")?.withRenderingMode(.alwaysTemplate))
        square.frame = CGRect(origin: CGPoint(x: 110, y: 279), size: CGSize(width: 100, height: 100))
        square.tintColor = .darkGray
        square.isUserInteractionEnabled = true
        return square
    }()
    
    private lazy var attachmentView: UIImageView = {
        let attachmentView = UIImageView(image: UIImage(named: "AttachmentPoint_Mask")?.withRenderingMode(.alwaysTemplate))
        attachmentView.frame.origin = CGPoint(x: 154, y: 123)
        attachmentView.tintColor = .red
        return attachmentView
    }()
    
    private lazy var pendulumBehavior: PendulumBehavior = {
        let pendulumBehavior = PendulumBehavior(item: square, suspendedFrom: self.attachmentView.center)
        return pendulumBehavior
    }()
    
    var animator: UIDynamicAnimator?

    override func loadView() {
        view = DecorationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(square)
        view.addSubview(attachmentView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleAttachmentGesture))
        square.addGestureRecognizer(pan)
        
        // Visually show the connection between the attachmentPoint and the square.
        (view as? DecorationView)?.trackAndDrawAttachment(from: attachmentView, toView: square, withAttachmentOffset: CGPoint(x: 0, y:-0.95 * self.square.bounds.height/2))

        let animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(pendulumBehavior)
        self.animator = animator
    }
    
    @objc func handleAttachmentGesture(_ sender: UIPanGestureRecognizer) {
        if (sender.state == .began) {
            pendulumBehavior.beginDraggingWeight(at: sender.location(in: view))
        } else if (sender.state == .ended) {
            pendulumBehavior.endDraggingWeight(with: sender.velocity(in: view))
        } else if (sender.state == .cancelled) {
            sender.isEnabled = true
            pendulumBehavior.endDraggingWeight(with: sender.velocity(in: view))
            
        } else if (!square.bounds.contains(sender.location(in: square))) {
            // End the gesture if the user's finger moved outside square1's bounds.
            // This causes the gesture to transition to the cencelled state.
            sender.isEnabled = false
        } else {
            pendulumBehavior.dragWeight(to: sender.location(in: view))
        }
    }
}
