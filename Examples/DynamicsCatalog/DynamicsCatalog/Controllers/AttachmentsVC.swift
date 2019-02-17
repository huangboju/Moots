//
//  AttachmentsVC.swift
//  DynamicsCatalog
//
//  Created by 黄伯驹 on 2019/2/17.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class AttachmentsVC: UIViewController {
    
    private lazy var square: UIImageView = {
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
        return square1AttachmentView
    }()
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.view)
        return animator
    }()
    
    private var attachmentBehavior: UIAttachmentBehavior!
    
    override func loadView() {
        view = DecorationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(square)
        view.addSubview(attachmentView)
        square.addSubview(square1AttachmentView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleAttachmentGesture))
        view.addGestureRecognizer(pan)

        
        let gravityBeahvior = UIGravityBehavior(items: [square])
        animator.addBehavior(gravityBeahvior)
        
        let collisionBehavior = UICollisionBehavior(items: [square])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
        
        let squareCenterPoint = CGPoint(x: square.center.x, y: square.center.y - 110.0)
        
        let attachmentPoint = UIOffset(horizontal: -25, vertical: -25)
        // By default, an attachment behavior uses the center of a view. By using a
        // small offset, we get a more interesting effect which will cause the view
        // to have rotation movement when dragging the attachment.
        
        attachmentBehavior = UIAttachmentBehavior(item: square, offsetFromCenter: attachmentPoint, attachedToAnchor: squareCenterPoint)
        animator.addBehavior(attachmentBehavior)
        
        // Visually show the attachment points
        attachmentView.center = attachmentBehavior.anchorPoint
        
        square1AttachmentView.center = CGPoint(x: 25.0, y: 25.0)
        
        // Visually show the connection between the attachment points.
        (view as? DecorationView)?.trackAndDrawAttachmentFromView(attachmentView, toView: square, withAttachmentOffset: CGPoint(x: -25.0, y: -25.0))
    }
    
    @objc func handleAttachmentGesture(_ sender: UIPanGestureRecognizer) {
        attachmentBehavior?.anchorPoint = sender.location(in: view)
        attachmentView.center = attachmentBehavior.anchorPoint
    }
}
