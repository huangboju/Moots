//
//  ViewController.swift
//  WaterWave
//
//  Created by 伯驹 黄 on 16/9/29.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v = WaterWaveView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        view.addSubview(v)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

