//
//  GravityVC.swift
//  DynamicsCatalog
//
//  Created by 黄伯驹 on 2019/2/16.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class GravityVC: UIViewController {
    
    private lazy var square: UIImageView = {
        let square = UIImageView(image: UIImage(named: "Box1"))
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
        square.frame.origin = CGPoint(x: 100, y: 100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let gravityBeahvior = UIGravityBehavior(items: [square])
        animator.addBehavior(gravityBeahvior)
    }
}
