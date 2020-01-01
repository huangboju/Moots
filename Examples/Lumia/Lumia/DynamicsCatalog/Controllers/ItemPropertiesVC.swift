//
//  ItemPropertiesVC.swift
//  Lumia
//
//  Created by 黄伯驹 on 2020/1/1.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import UIKit

class ItemPropertiesVC: UIViewController {
    
    private lazy var square: UIImageView = {
        let square = UIImageView(image: UIImage(named: "Box1")?.withRenderingMode(.alwaysTemplate))
        square.frame = CGRect(origin: CGPoint(x: 110, y: 279), size: CGSize(width: 100, height: 100))
        square.tintColor = .darkGray
        square.isUserInteractionEnabled = true
        return square
    }()
    
    private lazy var square1: UIImageView = {
        let square = UIImageView(image: UIImage(named: "Box1")?.withRenderingMode(.alwaysTemplate))
        square.frame = CGRect(origin: CGPoint(x: 250, y: 279), size: CGSize(width: 100, height: 100))
        square.tintColor = .darkGray
        square.isUserInteractionEnabled = true
        return square
    }()
    
    private lazy var square2PropertiesBehavior: UIDynamicItemBehavior = {
        let square2PropertiesBehavior = UIDynamicItemBehavior(items: [square1])
        square2PropertiesBehavior.elasticity = 0.5
        return square2PropertiesBehavior
    }()
    
    private lazy var square1PropertiesBehavior: UIDynamicItemBehavior = {
        let square1PropertiesBehavior = UIDynamicItemBehavior(items: [square])
        return square1PropertiesBehavior
    }()
    
    var animator: UIDynamicAnimator?
    
    override func loadView() {
        view = DecorationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(square)
        view.addSubview(square1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Replay", style: .plain, target: self, action: #selector(replayAction))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let animator = UIDynamicAnimator(referenceView: view)
        
        // We want to show collisions between views and boundaries with different
        // elasticities, we thus associate the two views to gravity and collision
        // behaviors. We will only change the restitution parameter for one of these
        // views.
        
        let gravityBeahvior = UIGravityBehavior(items: [square, square1])
        
        let collisionBehavior = UICollisionBehavior(items: [square, square1])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true

        // A dynamic item behavior gives access to low-level properties of an item
        // in Dynamics, here we change restitution on collisions only for square2,
        // and keep square1 with its default value.
        
        // A dynamic item behavior is created for square1 so it's velocity can be
        // manipulated in the -resetAction: method.


        animator.addBehavior(square1PropertiesBehavior)
        animator.addBehavior(square2PropertiesBehavior)
        animator.addBehavior(gravityBeahvior)
        animator.addBehavior(collisionBehavior)
        self.animator = animator
    }
    
    @objc func replayAction() {
        
        square1PropertiesBehavior.addLinearVelocity(CGPoint(x: 0, y: -1 * square1PropertiesBehavior.linearVelocity(for: square).y), for: square)

        square.center = CGPoint(x: 90, y: 171)
        animator?.updateItem(usingCurrentState: square)
        
        square2PropertiesBehavior.addLinearVelocity(CGPoint(x: 0, y: -1 * square2PropertiesBehavior.linearVelocity(for: square1).y), for: square1)
        square1.center = CGPoint(x: 230, y: 171)
        animator?.updateItem(usingCurrentState: square1)
    }
}
