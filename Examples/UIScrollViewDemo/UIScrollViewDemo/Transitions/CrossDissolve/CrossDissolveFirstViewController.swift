//
//  CrossDissolveFirstViewController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/12.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class CrossDissolveFirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let secondVC = CrossDissolveSecondViewController()
        
        // Setting the modalPresentationStyle to FullScreen enables the
        // <ContextTransitioning> to provide more accurate initial and final frames
        // of the participating view controllers
        secondVC.modalPresentationStyle = .fullScreen
        
        // The transitioning delegate can supply a custom animation controller
        // that will be used to animate the incoming view controller.
        secondVC.transitioningDelegate = self
        
        present(secondVC, animated: true, completion: nil)
    }
}

extension CrossDissolveFirstViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossDissolveTransitionAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossDissolveTransitionAnimator()
    }
}
