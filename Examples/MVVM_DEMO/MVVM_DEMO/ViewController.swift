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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraAction))
        camera.viewControllerForAlerts = self
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic_action_back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic_action_back")
    }
    
    func cameraAction() {
        switch camera.statusCamera() {
        case .authorized:
            let alert = UIAlertController(title: "", message: "相机已开", preferredStyle: .alert)
            let action = UIAlertAction(title: "好", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        default:
            camera.requestCamera()
        }
        
    }
    
    fileprivate lazy var button: UIButton = {
        let button = UIButton(frame: self.view.frame.insetBy(dx: 100, dy: 250))
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        button.backgroundColor = .blue
        return button
    }()
    
    func action(_ sender: UIButton) {
        navigationController?.pushViewController(TableView(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

