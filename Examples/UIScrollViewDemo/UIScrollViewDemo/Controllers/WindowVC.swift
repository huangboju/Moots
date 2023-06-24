//
//  WindowVC.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2019/2/20.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import UIKit

// https://medium.com/@evicoli/creating-custom-notification-ios-banner-sliding-over-status-bar-4a7b5f842307

class WindowVC: UIViewController {
    
    deinit {
        window?.removeFromSuperview()
        window = nil
    }
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let bannerWindow = UIWindow(frame: CGRect(x: 15, y: -200, width: view.frame.width - 30, height: 200))
        bannerWindow.layer.cornerRadius = 12
        bannerWindow.layer.masksToBounds = true
        bannerWindow.windowLevel = UIWindow.Level.statusBar
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        bannerWindow.rootViewController = vc
        window = bannerWindow
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        window?.isHidden = false
        UIWindow.animate(withDuration: 0.3) {
            self.window?.frame.origin.y = 32
        }
    }
}
