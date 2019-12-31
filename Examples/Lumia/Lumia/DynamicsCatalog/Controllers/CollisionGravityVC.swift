//
//  CollisionGravityVC.swift
//  DynamicsCatalog
//
//  Created by 黄伯驹 on 2019/2/17.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class CollisionGravityVC: UIViewController {
    
    private lazy var square: UIImageView = {
        let square = UIImageView(image: UIImage(named: "Box1")?.withRenderingMode(.alwaysTemplate))
        square.frame.origin = CGPoint(x: 100, y: 100)
        square.tintColor = .darkGray
        return square
    }()
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.view)
        return animator
    }()
    
    override func loadView() {
        view = DecorationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(square)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let gravityBeahvior = UIGravityBehavior(items: [square])
        animator.addBehavior(gravityBeahvior)
        
        let collisionBehavior = UICollisionBehavior(items: [square])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionDelegate = self
        animator.addBehavior(collisionBehavior)
    }
}

extension CollisionGravityVC: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        (item as? UIView)?.tintColor = .lightGray
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        (item as? UIView)?.tintColor = .darkGray
    }
}
