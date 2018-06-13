//
//  SecondVC.swift
//  MagicMove
//
//  Created by 黄伯驹 on 2018/6/13.
//  Copyright © 2018 Bourne. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {
    
    private lazy var dismissAnimator: DismissAnimator = {
        return DismissAnimator()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(pan)
    }

    @objc func panGesture(_ edgePan: UIPanGestureRecognizer) {

        let progress = edgePan.translation(in: view).x / view.bounds.width

        if edgePan.state == .began {
            if edgePan.velocity(in: view).x < 0 { return }
            dismissAnimator.begin()
            transitioningDelegate = dismissAnimator
            dismiss(animated: true, completion: nil)
        } else if edgePan.state == .changed {
            dismissAnimator.update(progress)
        } else if edgePan.state == .cancelled || edgePan.state == .ended {
            if progress > 0.2 {
                dismissAnimator.finish()
            } else {
                dismissAnimator.cancel()
            }
            dismissAnimator.invalidate()
        }
    }
}
