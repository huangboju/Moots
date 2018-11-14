//
//  AdaptivePresentationSecondViewController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/11/14.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class AdaptivePresentationSecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissButton = UIBarButtonItem(title: "dismiss", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissAction))
        navigationItem.leftBarButtonItem = dismissButton

        view.backgroundColor = UIColor(hex: 0x7DD1F0)
    }
    
    @objc
    func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
    override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        didSet {
            presentationController?.delegate = self
        }
    }
}

extension AdaptivePresentationSecondViewController: UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .fullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
}
