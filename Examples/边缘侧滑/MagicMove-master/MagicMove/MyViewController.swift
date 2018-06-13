//
//  MyViewController.swift
//  MagicMove
//
//  Created by xiAo_Ju on 2018/6/12.
//  Copyright © 2018 Bourne. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    
    private lazy var pushAnimator: PresentingAnimator = {
        return PresentingAnimator()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showNewVC))

        //手势监听器
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture))
        edgePan.edges = .right
        view.addGestureRecognizer(edgePan)
    }

    @objc
    func showNewVC() {
        let vc = SecondVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func edgePanGesture(edgePan: UIScreenEdgePanGestureRecognizer) {
        let progress = abs(edgePan.translation(in: view).x / view.bounds.width)

        if edgePan.state == .began {
            pushAnimator.begin()
            let vc = SecondVC()
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = pushAnimator
            present(vc, animated: true, completion: nil)
        } else if edgePan.state == .changed {
            pushAnimator.update(progress)
        } else if edgePan.state == .cancelled || edgePan.state == .ended {
            if progress > 0.2 {
                pushAnimator.finish()
            } else {
                pushAnimator.cancel()
            }
            pushAnimator.invalidate()
        }
    }
}
