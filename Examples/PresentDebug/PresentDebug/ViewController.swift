//
//  ViewController.swift
//  PresentDebug
//
//  Created by xiAo_Ju on 2018/10/18.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0xFF00) >> 8) / 255
        let blue = CGFloat(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

class ViewController: UIViewController {
    
    lazy var presentationManager = PresentationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0xFF6369)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "dismiss", style: .plain, target: self, action: #selector(dismissAction))
        
        definesPresentationContext = true
    }
    
    @objc
    func dismissAction() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let presentingVC = PresentingViewController()
        presentingVC.transitioningDelegate = presentationManager
        presentingVC.modalPresentationStyle = .overCurrentContext
        present(presentingVC, animated: true, completion: nil)
    }
}

