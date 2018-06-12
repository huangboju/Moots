//
//  MyViewController.swift
//  MagicMove
//
//  Created by xiAo_Ju on 2018/6/12.
//  Copyright © 2018 Bourne. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    
    var percentDrivenTransition: UIPercentDrivenInteractiveTransition?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red

        navigationController?.delegate = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showNewVC))
        
        //手势监听器
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture))
        edgePan.edges = .right
        view.addGestureRecognizer(edgePan)
    }
    
    @objc
    func showNewVC() {
        let vc = MyViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func edgePanGesture(edgePan: UIScreenEdgePanGestureRecognizer) {
        let progress = abs(edgePan.translation(in: view).x / view.bounds.width)

        if edgePan.state == .began {
            percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            let vc = MyViewController()
//            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        } else if edgePan.state == .changed {
            percentDrivenTransition?.update(progress)
        } else if edgePan.state == .cancelled || edgePan.state == .ended {
            if progress > 0.5 {
                percentDrivenTransition?.finish()
            } else {
                percentDrivenTransition?.cancel()
            }
            percentDrivenTransition = nil
        }
    }
}

extension MyViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return MagicMovePushTransion()
        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is MagicMovePushTransion {
            return percentDrivenTransition
        } else {
            return nil
        }
    }
}
