//
//  MotionBlurVC.swift
//  CoreImageStudy
//
//  Created by 黄伯驹 on 2019/2/14.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class MotionBlurVC: UIViewController {
    
    private lazy var displayView: DisplayView = {
        let displayView = DisplayView()
        displayView.translatesAutoresizingMaskIntoConstraints = false
        return displayView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(displayView)
        displayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        displayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        displayView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 15).isActive = true
        displayView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -15).isActive = true
    }
}

extension UIView {
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
}
