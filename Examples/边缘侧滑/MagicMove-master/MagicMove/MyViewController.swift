//
//  MyViewController.swift
//  MagicMove
//
//  Created by xiAo_Ju on 2018/6/12.
//  Copyright © 2018 Bourne. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    
    deinit {
        print("sdsdhshdshds")
    }
    
    private lazy var pushAnimator: PresentingAnimator = {
        return PresentingAnimator()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showNewVC))

        //手势监听器
        
        let edgePan = MyScreenEdgePanGestureRecognizer { [weak self] animator in
            let vc = SecondVC()
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = animator
            self?.present(vc, animated: true, completion: nil)
        }
        edgePan.edges = .right
        view.addGestureRecognizer(edgePan)
    }

    @objc
    func showNewVC() {
        let vc = MyViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
