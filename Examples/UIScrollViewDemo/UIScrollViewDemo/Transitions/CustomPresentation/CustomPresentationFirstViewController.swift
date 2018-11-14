//
//  CustomPresentationFirstViewController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/13.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class CustomPresentationFirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let secondViewController = CustomPresentationSecondViewController()
        let presentationController = CustomPresentationController(presentedViewController: secondViewController, presenting: self)
        withExtendedLifetime(presentationController) {
            secondViewController.transitioningDelegate = presentationController
            
            present(secondViewController, animated: true, completion: nil)
        }
    }
}
