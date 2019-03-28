//
//  DetailViewController.swift
//  PresentDebug
//
//  Created by xiAo_Ju on 2018/10/18.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    lazy var presentationManager = PresentationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: 0x7DD1F0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        showNewVC()
        
        pushNewVC()
    }
    
    func pushNewVC() {
        show(DetailViewController(), sender: nil)
    }
    
    func showNewVC() {
        let presentingVC = PresentingViewController()
        presentingVC.transitioningDelegate = presentationManager
        presentingVC.modalPresentationStyle = .custom
        present(presentingVC, animated: true, completion: nil)
    }
}
