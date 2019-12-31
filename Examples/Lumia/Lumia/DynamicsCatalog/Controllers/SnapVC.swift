//
//  SnapVC.swift
//  Lumia
//
//  Created by 黄伯驹 on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class SnapVC: UIViewController {
    
    private lazy var square: UIImageView = {
        let square = UIImageView(image: UIImage(named: "Box1"))
        return square
    }()
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.view)
        return animator
    }()
    
    var snapBehavior: UISnapBehavior?
    
    override func loadView() {
        view = DecorationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        square.frame.origin = CGPoint(x: 200, y: 200)
        view.addSubview(square)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleSnapGesture))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleSnapGesture(_ gesture: UITapGestureRecognizer) {
        
        let point = gesture.location(in: view)
        
        // Remove the previous behavior.
        if let snap = snapBehavior {
            animator.removeBehavior(snap)
        }

        let snapBehavior = UISnapBehavior(item: square, snapTo: point)
        animator.addBehavior(snapBehavior)

        self.snapBehavior = snapBehavior
    }
}
