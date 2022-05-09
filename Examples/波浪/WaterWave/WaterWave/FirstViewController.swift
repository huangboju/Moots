//
//  FirstViewController.swift
//  WaterWave
//
//  Created by 伯驹 黄 on 2017/2/9.
//  Copyright © 2017年 xiAo_Ju. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let v = WaterWaveView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        view.addSubview(v)
        
        let waterWaveView = NYWaterWaveView(frame: CGRect(x: 0, y: 300, width: view.frame.width, height: 200))
        view.addSubview(waterWaveView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
