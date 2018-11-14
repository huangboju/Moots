//
//  AdaptivePresentationFirstViewController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/14.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class AdaptivePresentationFirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let secondViewController = AdaptivePresentationSecondViewController()
        let presentationController = AdaptivePresentationController(presentedViewController: secondViewController, presenting: self)
        withExtendedLifetime(presentationController) {
            secondViewController.transitioningDelegate = presentationController
            
            present(secondViewController, animated: true, completion: nil)
        }
    }
}
