//
//  DetailViewController.swift
//  MagicMove
//
//  Created by BourneWeng on 15/7/13.
//  Copyright (c) 2015年 Bourne. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    var image: UIImage!
    
    var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    
    private lazy var popTransion: MagicMovePopTransion = {
       return MagicMovePopTransion()
    }()
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        //手势监听器
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }

    @objc func edgePanGesture(edgePan: UIScreenEdgePanGestureRecognizer) {
        let progress = edgePan.translation(in: view).x / view.bounds.width

        if edgePan.state == .began {
            percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewController(animated: true)
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

extension DetailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return popTransion
        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is MagicMovePopTransion {
            return percentDrivenTransition
        } else {
            return nil
        }
    }
}
