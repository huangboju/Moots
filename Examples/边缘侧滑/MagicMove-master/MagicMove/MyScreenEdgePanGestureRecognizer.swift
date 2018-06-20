//
//  MyScreenEdgePanGestureRecognizer.swift
//  MagicMove
//
//  Created by 黄伯驹 on 2018/6/20.
//  Copyright © 2018 Bourne. All rights reserved.
//

import UIKit

class MyScreenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer {

    private lazy var pushAnimator: PresentingAnimator = {
        return PresentingAnimator()
    }()
    
    private var handle:((PresentingAnimator) -> Void)?
    
    convenience init(_ handle:((PresentingAnimator) -> Void)?) {
        self.init()
        self.handle = handle
        addTarget(self, action: #selector(edgePanGesture))
    }
    
    @objc func edgePanGesture(edgePan: UIScreenEdgePanGestureRecognizer) {
        let progress = abs(edgePan.translation(in: edgePan.view!).x / edgePan.view!.bounds.width)
        if edgePan.state == .began {
            pushAnimator.begin()
            handle?(pushAnimator)
        } else if edgePan.state == .changed {
            pushAnimator.update(progress)
        } else if edgePan.state == .cancelled || edgePan.state == .ended {
            if progress > 0.15 {
                pushAnimator.finish()
            } else {
                pushAnimator.cancel()
            }
            pushAnimator.invalidate()
        }
    }
}
