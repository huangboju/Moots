//
//  AnimatedWaveViewVC.swift
//  Lumia
//
//  Created by xiAo_Ju on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class AnimatedWaveViewVC: UIViewController {

    var waveView: AnimatedWaveView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        buildWaveView()
    }
    
    func buildWaveView() {
        let animatedWaveView = AnimatedWaveView(frame: self.view.bounds)
        self.view.addSubview(animatedWaveView)
        waveView = animatedWaveView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        waveView?.makeWaves()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
