//
//  ViewController.swift
//  MVVM_DEMO
//
//  Created by 伯驹 黄 on 16/5/23.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit
import PermissionScope

class ViewController: UIViewController {
    let camera = PermissionScope()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(button)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: #selector(cameraAction))
        camera.viewControllerForAlerts = self
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic_action_back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic_action_back")
    }
    
    func cameraAction() {
        switch camera.statusCamera() {
        case .Authorized:
            let alert = UIAlertController(title: "", message: "相机已开", preferredStyle: .Alert)
            let action = UIAlertAction(title: "好", style: .Cancel, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        default:
            camera.requestCamera()
        }
        
    }
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRectInset(self.view.frame, 100, 250))
        button.addTarget(self, action: #selector(action), forControlEvents: .TouchUpInside)
        button.backgroundColor = .blueColor()
        return button
    }()
    
    func action(sender: UIButton) {
        navigationController?.pushViewController(TableView(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

