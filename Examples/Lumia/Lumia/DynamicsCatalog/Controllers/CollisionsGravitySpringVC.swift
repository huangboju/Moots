//
//  CollisionsGravitySpringVC.swift
//  Lumia
//
//  Created by 黄伯驹 on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class CollisionsGravitySpringVC: UIViewController {
    
    private lazy var square1: UIImageView = {
        let square = UIImageView(image: UIImage(named: "Box1")?.withRenderingMode(.alwaysTemplate))
        square.frame.origin = CGPoint(x: 100, y: 300)
        square.tintColor = .darkGray
        return square
    }()
    
    private lazy var attachmentView: UIImageView = {
        let attachmentView = UIImageView(image: UIImage(named: "AttachmentPoint_Mask")?.withRenderingMode(.alwaysTemplate))
        attachmentView.tintColor = .red
        return attachmentView
    }()
    
    private lazy var square1AttachmentView: UIImageView = {
       let square1AttachmentView = UIImageView(image: UIImage(named: "AttachmentPoint_Mask")?.withRenderingMode(.alwaysTemplate))
        square1AttachmentView.tintColor = .blue
        square1AttachmentView.center = CGPoint(x: 50.0, y: 50.0)
        return square1AttachmentView
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Drag anywhere to move the square."
        textLabel.font = UIFont(name: "Chalkduster", size: 15)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    var attachmentBehavior: UIAttachmentBehavior?
    
    var animator: UIDynamicAnimator?
    
    override func loadView() {
        view = DecorationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(square1)
        view.addSubview(attachmentView)
        square1.addSubview(square1AttachmentView)

        view.addSubview(textLabel)
        textLabel.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleAttachmentGesture))
        view.addGestureRecognizer(pan)

        let animator = UIDynamicAnimator(referenceView: view)
        let gravityBeahvior = UIGravityBehavior(items: [square1])
        let collisionBehavior = UICollisionBehavior(items: [square1])

        let anchorPoint = CGPoint(x: square1.center.x, y: square1.center.y - 110.0)
        let attachmentBehavior = UIAttachmentBehavior(item: square1, attachedToAnchor: anchorPoint)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        // These parameters set the attachment in spring mode, instead of a rigid
        // connection.
        attachmentBehavior.frequency = 1
        attachmentBehavior.damping = 0.1

        // Visually show the attachment point.
        attachmentView.center = attachmentBehavior.anchorPoint

        // Visually show the connection between the attachment points.
        (view as? DecorationView)?.trackAndDrawAttachment(from: attachmentView, toView: square1, withAttachmentOffset: .zero)

        animator.addBehavior(attachmentBehavior)
        animator.addBehavior(collisionBehavior)
        animator.addBehavior(gravityBeahvior)

        self.animator = animator

        self.attachmentBehavior = attachmentBehavior
    }
    
    @objc func handleAttachmentGesture(_ sender: UIPanGestureRecognizer) {
        attachmentBehavior?.anchorPoint = sender.location(in: view)
        attachmentView.center = attachmentBehavior?.anchorPoint ?? .zero
    }
}
