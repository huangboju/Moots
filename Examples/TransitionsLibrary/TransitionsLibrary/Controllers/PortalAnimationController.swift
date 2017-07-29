//
//  ViewController.swift
//  TransitionsLibrary
//
//  Created by 伯驹 黄 on 16/8/30.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class PortalAnimationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: view.frame.insetBy(dx: 50, dy: 100))
        button.backgroundColor = UIColor.red
        button.titleLabel?.font = UIFont.systemFont(ofSize: 500)
        button.setTitle("1", for: UIControlState())
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        view.addSubview(button)
    }

    func action() {
        navigationController?.delegate = self
        navigationController?.pushViewController(TestController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension PortalAnimationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PortalAnimationTransitioning()
    }
}

